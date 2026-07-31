import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { SearchController } from './search.controller';
import { SearchService } from './search.service';
import { PlayerProfile, PlayerPosition } from '../players/entities/player-profile.entity';
import { ClubProfile } from '../clubs/entities/club-profile.entity';

@Module({
  imports: [TypeOrmModule.forFeature([PlayerProfile, PlayerPosition, ClubProfile])],
  controllers: [SearchController],
  providers: [SearchService],
  exports: [SearchService],
})
export class SearchModule {}
