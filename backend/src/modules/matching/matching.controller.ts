import { Controller, Get, Param, Query, UseGuards } from '@nestjs/common';
import { MatchingService } from './matching.service';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';

@Controller('matching')
@UseGuards(JwtAuthGuard)
export class MatchingController {
  constructor(private readonly matchingService: MatchingService) {}

  @Get('players/:clubId')
  async getMatchesForClub(
    @Param('clubId') clubId: string,
    @Query('limit') limit?: number,
  ) {
    return this.matchingService.getMatchesForClub(clubId, limit ? Number(limit) : 20);
  }

  @Get('clubs/:playerId')
  async getMatchesForPlayer(
    @Param('playerId') playerId: string,
    @Query('limit') limit?: number,
  ) {
    return this.matchingService.getMatchesForPlayer(playerId, limit ? Number(limit) : 20);
  }

  @Get('score')
  async getMatchScore(
    @Query('playerId') playerId: string,
    @Query('clubId') clubId: string,
  ) {
    return this.matchingService.calculateMatchScore(playerId, clubId);
  }
}
