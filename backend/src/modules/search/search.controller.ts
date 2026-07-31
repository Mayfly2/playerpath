import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { SearchService } from './search.service';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';

@Controller('search')
@UseGuards(JwtAuthGuard)
export class SearchController {
  constructor(private readonly searchService: SearchService) {}

  @Get('players')
  async searchPlayers(@Query() query: any) {
    return this.searchService.searchPlayers({
      position: query.position?.split(','),
      secondaryPosition: query.secondaryPosition,
      preferredFoot: query.preferredFoot,
      ageMin: query.ageMin ? Number(query.ageMin) : undefined,
      ageMax: query.ageMax ? Number(query.ageMax) : undefined,
      heightMin: query.heightMin ? Number(query.heightMin) : undefined,
      heightMax: query.heightMax ? Number(query.heightMax) : undefined,
      currentStep: query.currentStep ? Number(query.currentStep) : undefined,
      highestStep: query.highestStep ? Number(query.highestStep) : undefined,
      county: query.county,
      radius: query.radius ? Number(query.radius) : undefined,
      lat: query.lat ? Number(query.lat) : undefined,
      lng: query.lng ? Number(query.lng) : undefined,
      availability: query.availability,
      isVerified: query.isVerified === 'true',
      statGoals: query.statGoals ? Number(query.statGoals) : undefined,
      statAssists: query.statAssists ? Number(query.statAssists) : undefined,
      sort: query.sort,
      page: query.page ? Number(query.page) : 1,
      limit: query.limit ? Number(query.limit) : 20,
    });
  }

  @Get('clubs')
  async searchClubs(@Query() query: any) {
    return this.searchService.searchClubs({
      league: query.league,
      step: query.step ? Number(query.step) : undefined,
      radius: query.radius ? Number(query.radius) : undefined,
      lat: query.lat ? Number(query.lat) : undefined,
      lng: query.lng ? Number(query.lng) : undefined,
      hasTrials: query.hasTrials === 'true',
      trainingDays: query.trainingDays,
      sort: query.sort,
      page: query.page ? Number(query.page) : 1,
      limit: query.limit ? Number(query.limit) : 20,
    });
  }
}
