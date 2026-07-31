import {
  Injectable, BadRequestException, UnauthorizedException,
  ConflictException, NotFoundException, Logger,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import * as bcrypt from 'bcrypt';
import { v4 as uuidv4 } from 'uuid';
import { User, AuthProvider } from '../users/entities/user.entity';
import {
  SignupDto, LoginDto, GoogleAuthDto, AppleAuthDto,
  ForgotPasswordDto, ResetPasswordDto,
} from './dto/auth.dto';

@Injectable()
export class AuthService {
  private readonly logger = new Logger(AuthService.name);
  private readonly SALT_ROUNDS = 12;

  constructor(
    @InjectRepository(User)
    private readonly userRepo: Repository<User>,
    private readonly jwtService: JwtService,
  ) {}

  async signup(dto: SignupDto) {
    const existing = await this.userRepo.findOne({ where: { email: dto.email } });
    if (existing) {
      throw new ConflictException('Email already registered');
    }

    const passwordHash = await bcrypt.hash(dto.password, this.SALT_ROUNDS);
    const verificationToken = uuidv4();

    const user = this.userRepo.create({
      email: dto.email,
      passwordHash,
      userType: dto.userType,
      authProvider: AuthProvider.EMAIL,
      emailVerificationToken: verificationToken,
    });

    await this.userRepo.save(user);
    this.logger.log(`New user registered: ${user.email}`);

    // TODO: Send verification email

    const tokens = await this.generateTokens(user);
    return { user: this.sanitizeUser(user), ...tokens };
  }

  async login(dto: LoginDto) {
    const user = await this.userRepo.findOne({
      where: { email: dto.email },
      select: { id: true, email: true, passwordHash: true, userType: true, isVerified: true, isActive: true },
    });

    if (!user || !user.passwordHash) {
      throw new UnauthorizedException('Invalid email or password');
    }

    if (!user.isActive) {
      throw new UnauthorizedException('Account has been deactivated');
    }

    const isValid = await bcrypt.compare(dto.password, user.passwordHash);
    if (!isValid) {
      throw new UnauthorizedException('Invalid email or password');
    }

    await this.userRepo.update(user.id, { lastLogin: new Date() });
    const tokens = await this.generateTokens(user);
    return { user: this.sanitizeUser(user), ...tokens };
  }

  async googleAuth(dto: GoogleAuthDto) {
    // Verify Google ID token
    const payload = await this.verifyGoogleToken(dto.idToken);

    let user = await this.userRepo.findOne({
      where: { googleId: payload.sub },
    });

    if (!user) {
      // Check if email exists (link accounts)
      user = await this.userRepo.findOne({ where: { email: payload.email } });
      if (user) {
        user.googleId = payload.sub;
        await this.userRepo.save(user);
      } else {
        user = this.userRepo.create({
          email: payload.email,
          googleId: payload.sub,
          userType: dto.userType,
          authProvider: AuthProvider.GOOGLE,
          isVerified: true, // Google accounts are pre-verified
        });
        await this.userRepo.save(user);
      }
    }

    const tokens = await this.generateTokens(user);
    return { user: this.sanitizeUser(user), ...tokens };
  }

  async appleAuth(dto: AppleAuthDto) {
    // Verify Apple identity token
    const payload = await this.verifyAppleToken(dto.identityToken);

    let user = await this.userRepo.findOne({
      where: { appleId: payload.sub },
    });

    if (!user) {
      user = this.userRepo.create({
        email: payload.email || `${payload.sub}@apple.user`,
        appleId: payload.sub,
        userType: dto.userType,
        authProvider: AuthProvider.APPLE,
        isVerified: true,
      });
      await this.userRepo.save(user);
    }

    const tokens = await this.generateTokens(user);
    return { user: this.sanitizeUser(user), ...tokens };
  }

  async verifyEmail(token: string) {
    const user = await this.userRepo.findOne({
      where: { emailVerificationToken: token },
    });

    if (!user) {
      throw new BadRequestException('Invalid or expired verification token');
    }

    user.isVerified = true;
    user.emailVerificationToken = null as any;
    await this.userRepo.save(user);

    return { message: 'Email verified successfully' };
  }

  async forgotPassword(dto: ForgotPasswordDto) {
    const user = await this.userRepo.findOne({ where: { email: dto.email } });
    if (!user) {
      // Don't reveal whether email exists
      return { message: 'If the email exists, a reset link has been sent' };
    }

    const resetToken = uuidv4();
    user.passwordResetToken = resetToken;
    user.passwordResetExpires = new Date(Date.now() + 3600000); // 1 hour
    await this.userRepo.save(user);

    // TODO: Send reset email
    this.logger.log(`Password reset token generated for: ${user.email}`);
    return { message: 'If the email exists, a reset link has been sent' };
  }

  async resetPassword(dto: ResetPasswordDto) {
    const user = await this.userRepo.findOne({
      where: { passwordResetToken: dto.token },
    });

    if (!user || !user.passwordResetExpires || user.passwordResetExpires < new Date()) {
      throw new BadRequestException('Invalid or expired reset token');
    }

    user.passwordHash = await bcrypt.hash(dto.newPassword, this.SALT_ROUNDS);
    user.passwordResetToken = null as any;
    user.passwordResetExpires = null as any;
    await this.userRepo.save(user);

    return { message: 'Password reset successfully' };
  }

  async refreshTokens(refreshToken: string) {
    try {
      const payload = this.jwtService.verify(refreshToken, {
        secret: process.env.JWT_REFRESH_SECRET || process.env.JWT_SECRET,
      });

      const user = await this.userRepo.findOne({ where: { id: payload.sub } });
      if (!user) throw new UnauthorizedException();

      const isValid = await bcrypt.compare(refreshToken, user.refreshTokenHash || '');
      if (!isValid) throw new UnauthorizedException();

      const tokens = await this.generateTokens(user);
      return tokens;
    } catch {
      throw new UnauthorizedException('Invalid refresh token');
    }
  }

  async logout(userId: string) {
    await this.userRepo.update(userId, { refreshTokenHash: undefined as any });
    return { message: 'Logged out' };
  }

  // ---- Private helpers ----

  private async generateTokens(user: User) {
    const payload = { sub: user.id, email: user.email, userType: user.userType };

    const accessToken = this.jwtService.sign(payload, {
      expiresIn: (process.env.JWT_ACCESS_EXPIRY || '15m') as any,
    });

    const refreshToken = this.jwtService.sign(payload, {
      secret: process.env.JWT_REFRESH_SECRET || process.env.JWT_SECRET,
      expiresIn: (process.env.JWT_REFRESH_EXPIRY || '7d') as any,
    });

    const refreshTokenHash = await bcrypt.hash(refreshToken, 6);
    await this.userRepo.update(user.id, { refreshTokenHash });

    return { accessToken, refreshToken };
  }

  private sanitizeUser(user: User) {
    const { passwordHash, refreshTokenHash, emailVerificationToken,
      passwordResetToken, passwordResetExpires, twoFactorSecret, ...safe } = user;
    return safe;
  }

  private async verifyGoogleToken(idToken: string): Promise<any> {
    // In production: verify with google-auth-library
    // For now decode the JWT without verification (dev mode)
    try {
      const payload = JSON.parse(Buffer.from(idToken.split('.')[1], 'base64').toString());
      return payload;
    } catch {
      throw new BadRequestException('Invalid Google token');
    }
  }

  private async verifyAppleToken(identityToken: string): Promise<any> {
    // In production: verify with apple-signin-auth
    try {
      const payload = JSON.parse(Buffer.from(identityToken.split('.')[1], 'base64').toString());
      return payload;
    } catch {
      throw new BadRequestException('Invalid Apple token');
    }
  }
}
