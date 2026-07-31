import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PlayersController } from './players.controller';
import { PlayersService } from './players.service';
import { PlayerProfile, PlayerPosition, PlayerStatistic, PlayerClubHistory, PlayerVideo } from './entities/player-profile.entity';
import { User } from '../users/entities/user.entity';

@Module({
  imports: [TypeOrmModule.forFeature([
    PlayerProfile, PlayerPosition, PlayerStatistic,
    PlayerClubHistory, PlayerVideo, User,
  ])],
  controllers: [PlayersController],
  providers: [PlayersService],
  exports: [PlayersService],
})
export class PlayersModule {}
