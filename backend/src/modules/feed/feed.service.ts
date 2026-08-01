import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { PlayerProfile } from '../players/entities/player-profile.entity';
import { ClubProfile } from '../clubs/entities/club-profile.entity';

@Injectable()
export class FeedService {
  constructor(
    @InjectRepository(PlayerProfile)
    private readonly playerRepo: Repository<PlayerProfile>,
    @InjectRepository(ClubProfile)
    private readonly clubRepo: Repository<ClubProfile>,
  ) {}

  async getFeed(userType: 'player' | 'club') {
    if (userType === 'player') {
      const [nearbyClubs, clubsWithTrials, suggestedClubs] = await Promise.all([
        this.getNearbyClubs(),
        this.getClubsWithTrials(),
        this.getSuggestedClubs(),
      ]);

      return {
        nearbyClubs,
        clubsWithTrials,
        suggestedClubs,
      };
    } else {
      const [nearbyPlayers, trendingPlayers] = await Promise.all([
        this.getNearbyPlayers(),
        this.getTrendingPlayers(),
      ]);

      return {
        nearbyPlayers,
        trendingPlayers,
      };
    }
  }

  private async getNearbyClubs() {
    return this.clubRepo.find({
      take: 6,
      order: { createdAt: 'DESC' },
    });
  }

  private async getClubsWithTrials() {
    return this.clubRepo.find({
      take: 4,
      order: { createdAt: 'DESC' },
    });
  }

  private async getSuggestedClubs() {
    return this.clubRepo.find({
      take: 6,
      order: { createdAt: 'DESC' },
    });
  }

  private async getNearbyPlayers() {
    return this.playerRepo.find({
      relations: { positions: true, statistics: true },
      take: 10,
      order: { lastActiveAt: 'DESC', createdAt: 'DESC' },
    });
  }

  private async getTrendingPlayers() {
    return this.playerRepo.find({
      relations: { positions: true, statistics: true },
      take: 6,
      order: { createdAt: 'DESC' },
    });
  }
}
