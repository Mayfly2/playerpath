import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { APP_FILTER, APP_GUARD, APP_INTERCEPTOR, APP_PIPE } from '@nestjs/core';
import { ThrottlerModule, ThrottlerGuard } from '@nestjs/throttler';
import { JwtModule } from '@nestjs/jwt';
import { HttpExceptionFilter } from './common/filters/http-exception.filter';
import { TransformInterceptor } from './common/interceptors/transform.interceptor';
import { LoggingInterceptor } from './common/interceptors/logging.interceptor';
import { ValidationPipe } from './common/pipes/validation.pipe';
import { JwtAuthGuard } from './common/guards/jwt-auth.guard';
import { AuthModule } from './modules/auth/auth.module';
import { UsersModule } from './modules/users/users.module';
import { PlayersModule } from './modules/players/players.module';
import { ClubsModule } from './modules/clubs/clubs.module';
import { SearchModule } from './modules/search/search.module';
import { MatchingModule } from './modules/matching/matching.module';
import { MessagingModule } from './modules/messaging/messaging.module';
import { UploadModule } from './modules/upload/upload.module';
import { VideoModule } from './modules/video/video.module';
import { TrialsModule } from './modules/trials/trials.module';
import { NotificationsModule } from './modules/notifications/notifications.module';
import { FeedModule } from './modules/feed/feed.module';
import { SavedListsModule } from './modules/saved-lists/saved-lists.module';
import { databaseConfig } from './config/database.config';
import { redisConfig } from './config/redis.config';
import { jwtConfig } from './config/jwt.config';
import { elasticsearchConfig } from './config/elasticsearch.config';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true, envFilePath: '.env' }),
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: databaseConfig,
    }),
    JwtModule.registerAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (config: ConfigService) => ({
        secret: config.get('JWT_SECRET', 'playerpath-dev-secret-change-in-production'),
        signOptions: { expiresIn: config.get('JWT_ACCESS_EXPIRY', '15m') },
      }),
    }),
    ThrottlerModule.forRoot([{ ttl: 60000, limit: 60 }]),
    AuthModule,
    UsersModule,
    PlayersModule,
    ClubsModule,
    SearchModule,
    MatchingModule,
    MessagingModule,
    UploadModule,
    VideoModule,
    TrialsModule,
    NotificationsModule,
    FeedModule,
    SavedListsModule,
  ],
  providers: [
    { provide: APP_FILTER, useClass: HttpExceptionFilter },
    { provide: APP_GUARD, useClass: JwtAuthGuard },
    { provide: APP_INTERCEPTOR, useClass: TransformInterceptor },
    { provide: APP_INTERCEPTOR, useClass: LoggingInterceptor },
    { provide: APP_PIPE, useClass: ValidationPipe },
    { provide: 'REDIS_CONFIG', useFactory: redisConfig, inject: [ConfigService] },
    { provide: 'JWT_CONFIG', useFactory: jwtConfig, inject: [ConfigService] },
    { provide: 'ELASTICSEARCH_CONFIG', useFactory: elasticsearchConfig, inject: [ConfigService] },
  ],
})
export class AppModule {}
