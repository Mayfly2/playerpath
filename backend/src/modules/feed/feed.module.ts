import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { FeedController } from './feed.controller';
import { FeedService } from './feed.service';
import { PlayerProfile } from '../players/entities/player-profile.entity';
import { ClubProfile } from '../clubs/entities/club-profile.entity';

@Module({
  imports: [TypeOrmModule.forFeature([PlayerProfile, ClubProfile])],
  controllers: [FeedController],
  providers: [FeedService],
})
export class FeedModule {}
