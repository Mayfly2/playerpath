import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TrialInvitation } from '../messaging/entities/messaging.entity';

@Module({
  imports: [TypeOrmModule.forFeature([TrialInvitation])],
  controllers: [],
  providers: [],
})
export class TrialsModule {}
