import {
  Entity, PrimaryGeneratedColumn, Column, CreateDateColumn,
  UpdateDateColumn, OneToOne,
} from 'typeorm';
import { PlayerProfile } from '../../players/entities/player-profile.entity';
import { ClubProfile } from '../../clubs/entities/club-profile.entity';

export enum UserType {
  PLAYER = 'player',
  CLUB = 'club',
  SCOUT = 'scout',
  AGENT = 'agent',
  COACH = 'coach',
  REFEREE = 'referee',
}

export enum AuthProvider {
  EMAIL = 'email',
  GOOGLE = 'google',
  APPLE = 'apple',
}

@Entity('users')
export class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ unique: true })
  email: string;

  @Column({ nullable: true, select: false })
  passwordHash: string;

  @Column({ type: 'varchar', enum: UserType, default: UserType.PLAYER })
  userType: UserType;

  @Column({ default: false })
  isVerified: boolean;

  @Column({ default: false })
  isPremium: boolean;

  @Column({ type: 'varchar', enum: AuthProvider, default: AuthProvider.EMAIL })
  authProvider: AuthProvider;

  @Column({ nullable: true })
  googleId: string;

  @Column({ nullable: true })
  appleId: string;

  @Column({ nullable: true })
  refreshTokenHash: string;

  @Column({ nullable: true })
  emailVerificationToken: string;

  @Column({ nullable: true })
  passwordResetToken: string;

  @Column({ nullable: true })
  passwordResetExpires: Date;

  @Column({ nullable: true })
  twoFactorSecret: string;

  @Column({ default: false })
  isTwoFactorEnabled: boolean;

  @Column({ default: true })
  isActive: boolean;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  @Column({ nullable: true })
  lastLogin: Date;

  @OneToOne(() => PlayerProfile, (profile) => profile.user, { cascade: true })
  playerProfile: PlayerProfile;

  @OneToOne(() => ClubProfile, (profile) => profile.user, { cascade: true })
  clubProfile: ClubProfile;
}
