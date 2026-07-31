import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { PlayerProfile, PlayerPosition } from '../players/entities/player-profile.entity';
import { ClubProfile } from '../clubs/entities/club-profile.entity';

export interface MatchResult {
  player: Partial<PlayerProfile>;
  club: Partial<ClubProfile>;
  score: number;
  tier: 'Excellent' | 'Good' | 'Potential' | 'Low';
  breakdown: Record<string, number>;
}

@Injectable()
export class MatchingService {
  private readonly logger = new Logger(MatchingService.name);

  constructor(
    @InjectRepository(PlayerProfile)
    private readonly playerRepo: Repository<PlayerProfile>,
    @InjectRepository(ClubProfile)
    private readonly clubRepo: Repository<ClubProfile>,
  ) {}

  /**
   * Calculate compatibility score between a player and club.
   * Returns 0-100 with breakdown of contributing factors.
   */
  async calculateMatchScore(playerId: string, clubId: string): Promise<MatchResult> {
    const player = await this.playerRepo.findOne({
      where: { id: playerId },
      relations: { positions: true },
    });
    const club = await this.clubRepo.findOne({ where: { id: clubId } });

    if (!player || !club) {
      throw new Error('Player or club not found');
    }

    const breakdown: Record<string, number> = {};

    // 1. Location proximity (25 points)
    breakdown.location = this.scoreLocation(player, club);

    // 2. Step level match (25 points)
    breakdown.stepMatch = this.scoreStepMatch(player, club);

    // 3. Position need (20 points)
    breakdown.positionFit = this.scorePositionFit(player, club);

    // 4. Availability (15 points)
    breakdown.availability = this.scoreAvailability(player);

    // 5. Experience (15 points)
    breakdown.experience = this.scoreExperience(player);

    const total = Object.values(breakdown).reduce((sum, val) => sum + val, 0);
    const score = Math.round(Math.min(total, 100));

    let tier: MatchResult['tier'] = 'Low';
    if (score >= 90) tier = 'Excellent';
    else if (score >= 75) tier = 'Good';
    else if (score >= 60) tier = 'Potential';

    return {
      player: { id: player.id, fullName: player.fullName, currentStep: player.currentStep },
      club: { id: club.id, clubName: club.clubName, step: club.step },
      score,
      tier,
      breakdown,
    };
  }

  /**
   * Get top matching players for a club.
   */
  async getMatchesForClub(clubId: string, limit = 20): Promise<MatchResult[]> {
    const club = await this.clubRepo.findOne({ where: { id: clubId } });
    if (!club) throw new Error('Club not found');

    // Get nearby players to score (optimization: limit pool)
    const players = await this.playerRepo.find({
      relations: { positions: true },
      take: 200,
      order: { createdAt: 'DESC' },
    });

    const results: MatchResult[] = [];
    for (const player of players) {
      let score = 0;
      score += this.scoreLocation(player, club);
      score += this.scoreStepMatch(player, club);
      score += this.scorePositionFit(player, club);
      score += this.scoreAvailability(player);
      score += this.scoreExperience(player);

      const finalScore = Math.round(Math.min(score, 100));
      let tier: MatchResult['tier'] = 'Low';
      if (finalScore >= 90) tier = 'Excellent';
      else if (finalScore >= 75) tier = 'Good';
      else if (finalScore >= 60) tier = 'Potential';

      results.push({
        player: { id: player.id, fullName: player.fullName, currentStep: player.currentStep },
        club: { id: club.id, clubName: club.clubName, step: club.step },
        score: finalScore,
        tier,
        breakdown: {},
      });
    }

    // Sort by score descending
    results.sort((a, b) => b.score - a.score);
    return results.slice(0, limit);
  }

  /**
   * Get top matching clubs for a player.
   */
  async getMatchesForPlayer(playerId: string, limit = 20): Promise<MatchResult[]> {
    const player = await this.playerRepo.findOne({
      where: { id: playerId },
      relations: { positions: true },
    });
    if (!player) throw new Error('Player not found');

    const clubs = await this.clubRepo.find({ take: 200 });
    const results: MatchResult[] = [];

    for (const club of clubs) {
      let score = 0;
      score += this.scoreLocation(player, club);
      score += this.scoreStepMatch(player, club);
      score += this.scorePositionFit(player, club);
      score += this.scoreAvailability(player);
      score += this.scoreExperience(player);

      const finalScore = Math.round(Math.min(score, 100));
      let tier: MatchResult['tier'] = 'Low';
      if (finalScore >= 90) tier = 'Excellent';
      else if (finalScore >= 75) tier = 'Good';
      else if (finalScore >= 60) tier = 'Potential';

      results.push({
        player: { id: player.id, fullName: player.fullName },
        club: { id: club.id, clubName: club.clubName, step: club.step },
        score: finalScore,
        tier,
        breakdown: {},
      });
    }

    results.sort((a, b) => b.score - a.score);
    return results.slice(0, limit);
  }

  // ---- Scoring Helpers ----

  private scoreLocation(player: PlayerProfile, club: ClubProfile): number {
    if (!player.locationLat || !player.locationLng || !club.locationLat || !club.locationLng) {
      return 10; // Neutral score if no location data
    }

    const distance = this.haversineDistance(
      player.locationLat, player.locationLng,
      club.locationLat, club.locationLng,
    );

    const maxRadius = player.travelRadiusKm || 50;
    if (distance <= 10) return 25;
    if (distance <= 25) return 20;
    if (distance <= maxRadius) return 15;
    if (distance <= maxRadius * 1.5) return 10;
    return 5;
  }

  private scoreStepMatch(player: PlayerProfile, club: ClubProfile): number {
    if (!player.currentStep || !club.step) return 12;

    const diff = Math.abs(player.currentStep - club.step);
    if (diff === 0) return 25;
    if (diff === 1) return 20;
    if (diff === 2) return 15;
    return 8;
  }

  private scorePositionFit(player: PlayerProfile, _club: ClubProfile): number {
    // In production, compare against club's needed positions
    // For MVP, reward players with positions defined
    if (!player.positions || player.positions.length === 0) return 5;
    const hasPrimary = player.positions.some((p) => p.isPrimary);
    return hasPrimary ? 20 : 15;
  }

  private scoreAvailability(player: PlayerProfile): number {
    switch (player.availability) {
      case 'immediate': return 15;
      case 'negotiable': return 10;
      default: return 5;
    }
  }

  private scoreExperience(player: PlayerProfile): number {
    let score = 0;
    if (player.highestStep) {
      // Higher step = more experience
      score += Math.min(player.highestStep, 7) * 1;
    }
    if (player.clubHistory && player.clubHistory.length > 0) {
      score += Math.min(player.clubHistory.length, 5);
    }
    return Math.min(score, 15);
  }

  private haversineDistance(lat1: number, lng1: number, lat2: number, lng2: number): number {
    const R = 6371; // Earth's radius in km
    const dLat = this.toRad(lat2 - lat1);
    const dLng = this.toRad(lng2 - lng1);
    const a =
      Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos(this.toRad(lat1)) * Math.cos(this.toRad(lat2)) *
      Math.sin(dLng / 2) * Math.sin(dLng / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return R * c;
  }

  private toRad(deg: number): number {
    return deg * (Math.PI / 180);
  }
}
