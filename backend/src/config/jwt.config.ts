import { ConfigService } from '@nestjs/config';

export const jwtConfig = (config: ConfigService) => ({
  secret: config.get('JWT_SECRET', 'playerpath-dev-secret-change-in-production'),
  accessTokenExpiry: config.get('JWT_ACCESS_EXPIRY', '15m'),
  refreshTokenExpiry: config.get('JWT_REFRESH_EXPIRY', '7d'),
});
