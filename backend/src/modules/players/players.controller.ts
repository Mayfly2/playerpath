import {
  Controller, Get, Post, Put, Patch, Delete, Body, Param, UseGuards,
} from '@nestjs/common';
import { PlayersService } from './players.service';
import { CreatePlayerProfileDto, AddPositionDto, AddStatisticDto, AddClubHistoryDto } from './dto/player-profile.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { CurrentUser } from '../../common/decorators/current-user.decorator';

@Controller('players')
@UseGuards(JwtAuthGuard)
export class PlayersController {
  constructor(private readonly playersService: PlayersService) {}

  @Post('profile')
  async createProfile(@CurrentUser() user: any, @Body() dto: CreatePlayerProfileDto) {
    return this.playersService.createProfile(user.id, dto);
  }

  @Get('profile')
  async getOwnProfile(@CurrentUser() user: any) {
    return this.playersService.getOwnProfile(user.id);
  }

  @Patch('profile')
  async updateProfile(@CurrentUser() user: any, @Body() dto: CreatePlayerProfileDto) {
    return this.playersService.updateProfile(user.id, dto);
  }

  @Get(':id')
  async getPublicProfile(@Param('id') id: string) {
    return this.playersService.getPublicProfile(id);
  }

  @Post('profile/positions')
  async addPosition(@CurrentUser() user: any, @Body() dto: AddPositionDto) {
    return this.playersService.addPosition(user.id, dto);
  }

  @Put('profile/positions')
  async updatePositions(@CurrentUser() user: any, @Body() positions: AddPositionDto[]) {
    return this.playersService.updatePositions(user.id, positions);
  }

  @Post('profile/statistics')
  async addStatistic(@CurrentUser() user: any, @Body() dto: AddStatisticDto) {
    return this.playersService.addStatistic(user.id, dto);
  }

  @Delete('profile/statistics/:statId')
  async deleteStatistic(@CurrentUser() user: any, @Param('statId') statId: string) {
    return this.playersService.deleteStatistic(user.id, statId);
  }

  @Post('profile/club-history')
  async addClubHistory(@CurrentUser() user: any, @Body() dto: AddClubHistoryDto) {
    return this.playersService.addClubHistory(user.id, dto);
  }

  @Delete('profile/club-history/:historyId')
  async deleteClubHistory(@CurrentUser() user: any, @Param('historyId') historyId: string) {
    return this.playersService.deleteClubHistory(user.id, historyId);
  }
}
