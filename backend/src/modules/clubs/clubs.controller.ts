import {
  Controller, Get, Post, Patch, Body, Param, UseGuards,
} from '@nestjs/common';
import { ClubsService } from './clubs.service';
import { CreateClubProfileDto } from './dto/club-profile.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { CurrentUser } from '../../common/decorators/current-user.decorator';

@Controller('clubs')
@UseGuards(JwtAuthGuard)
export class ClubsController {
  constructor(private readonly clubsService: ClubsService) {}

  @Post('profile')
  async createProfile(@CurrentUser() user: any, @Body() dto: CreateClubProfileDto) {
    return this.clubsService.createProfile(user.id, dto);
  }

  @Get('profile')
  async getOwnProfile(@CurrentUser() user: any) {
    return this.clubsService.getOwnProfile(user.id);
  }

  @Patch('profile')
  async updateProfile(@CurrentUser() user: any, @Body() dto: CreateClubProfileDto) {
    return this.clubsService.updateProfile(user.id, dto);
  }

  @Get(':id')
  async getPublicProfile(@Param('id') id: string) {
    return this.clubsService.getPublicProfile(id);
  }
}
