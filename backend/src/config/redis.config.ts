import { ConfigService } from '@nestjs/config';

export const redisConfig = (config: ConfigService) => ({
  host: config.get('REDIS_HOST', 'localhost'),
  port: config.get('REDIS_PORT', 6379),
  password: config.get('REDIS_PASSWORD', undefined),
  db: config.get('REDIS_DB', 0),
});
