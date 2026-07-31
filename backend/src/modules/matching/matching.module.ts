import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { MatchingController } from './matching.controller';
import { MatchingService } from './matching.service';
import { PlayerProfile, PlayerPosition } from '../players/entities/player-profile.entity';
import { ClubProfile } from '../clubs/entities/club-profile.entity';

@Module({
  imports: [TypeOrmModule.forFeature([PlayerProfile, PlayerPosition, ClubProfile])],
  controllers: [MatchingController],
  providers: [MatchingService],
  exports: [MatchingService],
})
export class MatchingModule {}
