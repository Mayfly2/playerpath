import { Injectable, Logger } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ConfigService } from '@nestjs/config';

/**
 * Apple OAuth Strategy (for web OAuth redirect flow)
 * Apple auth for mobile is handled via REST endpoint (POST /auth/apple)
 * using identity token verification directly in AuthService.
 */
@Injectable()
export class AppleStrategy extends PassportStrategy(
  // passport-apple has incomplete types; only loaded at runtime if available
  {
    name: 'apple',
    // Minimal stub to prevent module crash if passport-apple not installed
    _strategy: 'apple',
  } as any,
  'apple',
) {
  private readonly logger = new Logger(AppleStrategy.name);

  constructor(config: ConfigService) {
    super({
      clientID: config.get('APPLE_CLIENT_ID', ''),
      teamID: config.get('APPLE_TEAM_ID', ''),
      keyID: config.get('APPLE_KEY_ID', ''),
      keyFilePath: config.get('APPLE_KEY_FILE_PATH', ''),
      callbackURL: config.get('APPLE_CALLBACK_URL', ''),
      passReqToCallback: false,
    });
    this.logger.warn('AppleStrategy loaded in stub mode — mobile auth uses REST endpoint');
  }

  async validate(
    accessToken: string,
    refreshToken: string,
    idToken: string,
    profile: any,
    done: any,
  ): Promise<any> {
    const user = {
      appleId: profile?.id || idToken,
      email: profile?.email,
      accessToken,
    };
    done(null, user);
  }
}
