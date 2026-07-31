import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, SelectQueryBuilder } from 'typeorm';
import { PlayerProfile, PlayerPosition, Position } from '../players/entities/player-profile.entity';
import { ClubProfile } from '../clubs/entities/club-profile.entity';

export interface PlayerSearchParams {
  position?: string[];
  secondaryPosition?: string;
  preferredFoot?: string;
  ageMin?: number;
  ageMax?: number;
  heightMin?: number;
  heightMax?: number;
  currentStep?: number;
  highestStep?: number;
  county?: string;
  radius?: number;
  lat?: number;
  lng?: number;
  availability?: string;
  hasVideo?: boolean;
  isVerified?: boolean;
  statGoals?: number;
  statAssists?: number;
  sort?: 'newest' | 'nearest' | 'rating' | 'experience';
  page?: number;
  limit?: number;
}

export interface ClubSearchParams {
  league?: string;
  step?: number;
  teamType?: string;
  radius?: number;
  lat?: number;
  lng?: number;
  hasTrials?: boolean;
  trainingDays?: string;
  sort?: 'newest' | 'nearest';
  page?: number;
  limit?: number;
}

@Injectable()
export class SearchService {
  private readonly logger = new Logger(SearchService.name);

  constructor(
    @InjectRepository(PlayerProfile)
    private readonly playerRepo: Repository<PlayerProfile>,
    @InjectRepository(ClubProfile)
    private readonly clubRepo: Repository<ClubProfile>,
  ) {}

  async searchPlayers(params: PlayerSearchParams) {
    const page = params.page || 1;
    const limit = Math.min(params.limit || 20, 50);
    const offset = (page - 1) * limit;

    const qb = this.playerRepo.createQueryBuilder('player')
      .leftJoinAndSelect('player.positions', 'positions')
      .leftJoinAndSelect('player.statistics', 'statistics')
      .where('player.fullName IS NOT NULL');

    // Position filter
    if (params.position?.length) {
      qb.andWhere((qb2: SelectQueryBuilder<PlayerProfile>) => {
        const subQuery = qb2.subQuery()
          .select('pp2.id')
          .from(PlayerPosition, 'pp2')
          .where('pp2.position IN (:...positions)', { positions: params.position })
          .andWhere('pp2.profileId = player.id')
          .getQuery();
        return `EXISTS ${subQuery}`;
      });
    }

    // Preferred foot
    if (params.preferredFoot) {
      qb.andWhere('player.preferredFoot = :foot', { foot: params.preferredFoot });
    }

    // Age range (calculate from dateOfBirth)
    if (params.ageMin !== undefined || params.ageMax !== undefined) {
      const now = new Date();
      if (params.ageMax !== undefined) {
        const minDate = new Date(now.getFullYear() - params.ageMax - 1, now.getMonth(), now.getDate());
        qb.andWhere('player.dateOfBirth >= :minDate', { minDate });
      }
      if (params.ageMin !== undefined) {
        const maxDate = new Date(now.getFullYear() - params.ageMin, now.getMonth(), now.getDate());
        qb.andWhere('player.dateOfBirth <= :maxDate', { maxDate });
      }
    }

    // Height
    if (params.heightMin) qb.andWhere('player.heightCm >= :hMin', { hMin: params.heightMin });
    if (params.heightMax) qb.andWhere('player.heightCm <= :hMax', { hMax: params.heightMax });

    // Steps
    if (params.currentStep) qb.andWhere('player.currentStep = :step', { step: params.currentStep });
    if (params.highestStep) qb.andWhere('player.highestStep = :hStep', { hStep: params.highestStep });

    // County
    if (params.county) {
      qb.andWhere('LOWER(player.county) LIKE LOWER(:county)', { county: `%${params.county}%` });
    }

    // Location + radius (Haversine approximation)
    if (params.lat && params.lng && params.radius) {
      const radiusKm = params.radius;
      qb.andWhere(`
        (6371 * acos(cos(radians(:lat)) * cos(radians(player.locationLat))
        * cos(radians(player.locationLng) - radians(:lng))
        + sin(radians(:lat)) * sin(radians(player.locationLat))))
        <= :radius
      `, { lat: params.lat, lng: params.lng, radius: radiusKm });
    }

    // Availability
    if (params.availability) {
      qb.andWhere('player.availability = :avail', { avail: params.availability });
    }

    // Verified
    if (params.isVerified) {
      qb.andWhere('player.isVerifiedPlayer = TRUE');
    }

    // Statistics
    if (params.statGoals) {
      qb.andWhere('statistics.goals >= :goals', { goals: params.statGoals });
    }
    if (params.statAssists) {
      qb.andWhere('statistics.assists >= :assists', { assists: params.statAssists });
    }

    // Sorting
    switch (params.sort) {
      case 'newest':
        qb.orderBy('player.createdAt', 'DESC');
        break;
      case 'experience':
        qb.orderBy('player.highestStep', 'ASC');
        break;
      case 'nearest':
        if (params.lat && params.lng) {
          qb.orderBy(`
            (6371 * acos(cos(radians(:sortLat)) * cos(radians(player.locationLat))
            * cos(radians(player.locationLng) - radians(:sortLng))
            + sin(radians(:sortLat)) * sin(radians(player.locationLat))))
          `, 'ASC').setParameter('sortLat', params.lat).setParameter('sortLng', params.lng);
        } else {
          qb.orderBy('player.createdAt', 'DESC');
        }
        break;
      default:
        qb.orderBy('player.createdAt', 'DESC');
    }

    // Count total
    const total = await qb.getCount();

    // Paginate
    qb.skip(offset).take(limit);
    const players = await qb.getMany();

    return {
      players,
      meta: { page, limit, total, pages: Math.ceil(total / limit) },
    };
  }

  async searchClubs(params: ClubSearchParams) {
    const page = params.page || 1;
    const limit = Math.min(params.limit || 20, 50);
    const offset = (page - 1) * limit;

    const qb = this.clubRepo.createQueryBuilder('club')
      .where('club.clubName IS NOT NULL')
      .andWhere('club.isActive = TRUE');

    if (params.league) {
      qb.andWhere('LOWER(club.league) LIKE LOWER(:league)', { league: `%${params.league}%` });
    }
    if (params.step) {
      qb.andWhere('club.step = :step', { step: params.step });
    }
    if (params.hasTrials) {
      qb.andWhere('club.hasOpenTrials = TRUE');
    }
    if (params.trainingDays) {
      qb.andWhere('LOWER(club.trainingDays) LIKE LOWER(:days)', { days: `%${params.trainingDays}%` });
    }
    if (params.lat && params.lng && params.radius) {
      qb.andWhere(`
        (6371 * acos(cos(radians(:lat)) * cos(radians(club.locationLat))
        * cos(radians(club.locationLng) - radians(:lng))
        + sin(radians(:lat)) * sin(radians(club.locationLat))))
        <= :radius
      `, { lat: params.lat, lng: params.lng, radius: params.radius });
    }

    if (params.sort === 'nearest' && params.lat && params.lng) {
      qb.orderBy(`
        (6371 * acos(cos(radians(:sortLat)) * cos(radians(club.locationLat))
        * cos(radians(club.locationLng) - radians(:sortLng))
        + sin(radians(:sortLat)) * sin(radians(club.locationLat))))
      `, 'ASC').setParameter('sortLat', params.lat).setParameter('sortLng', params.lng);
    } else {
      qb.orderBy('club.createdAt', 'DESC');
    }

    const total = await qb.getCount();
    qb.skip(offset).take(limit);
    const clubs = await qb.getMany();

    return {
      clubs,
      meta: { page, limit, total, pages: Math.ceil(total / limit) },
    };
  }
}
