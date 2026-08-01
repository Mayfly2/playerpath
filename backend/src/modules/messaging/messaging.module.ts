import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { TypeOrmModule } from '@nestjs/typeorm';
import { MessagingController } from './messaging.controller';
import { MessagingService } from './messaging.service';
import { MessagingGateway } from './messaging.gateway';
import { Conversation, Message, TrialInvitation } from './entities/messaging.entity';
import { User } from '../users/entities/user.entity';
import { WsJwtGuard } from '../../common/guards/ws-jwt.guard';

@Module({
  imports: [
    TypeOrmModule.forFeature([Conversation, Message, TrialInvitation, User]),
    JwtModule.register({ secret: process.env.JWT_SECRET || 'dev-secret' }),
  ],
  controllers: [MessagingController],
  providers: [MessagingService, MessagingGateway, WsJwtGuard],
  exports: [MessagingService, MessagingGateway],
})
export class MessagingModule {}
