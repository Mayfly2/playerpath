import {
  Entity, PrimaryGeneratedColumn, Column, CreateDateColumn,
  UpdateDateColumn, OneToOne, ManyToOne, JoinColumn, OneToMany,
} from 'typeorm';
import { User } from '../../users/entities/user.entity';

export enum PreferredFoot {
  LEFT = 'left',
  RIGHT = 'right',
  BOTH = 'both',
}

export enum Availability {
  IMMEDIATE = 'immediate',
  NEGOTIABLE = 'negotiable',
  NOT_AVAILABLE = 'not_available',
}

@Entity('player_profiles')
export class PlayerProfile {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @OneToOne(() => User, (user) => user.playerProfile)
  @JoinColumn()
  user: User;

  @Column({ nullable: true })
  profilePhotoUrl: string;

  @Column({ nullable: true })
  coverPhotoUrl: string;

  @Column()
  fullName: string;

  @Column({ type: 'date', nullable: true })
  dateOfBirth: Date;

  @Column({ type: 'int', nullable: true })
  heightCm: number;

  @Column({ type: 'decimal', precision: 5, scale: 2, nullable: true })
  weightKg: number;

  @Column({ type: 'varchar', enum: PreferredFoot, nullable: true })
  preferredFoot: PreferredFoot;

  @Column({ nullable: true })
  nationality: string;

  @Column({ type: 'text', nullable: true })
  bio: string;

  @Column({ type: 'decimal', precision: 10, scale: 7, nullable: true })
  locationLat: number;

  @Column({ type: 'decimal', precision: 10, scale: 7, nullable: true })
  locationLng: number;

  @Column({ type: 'int', nullable: true })
  travelRadiusKm: number;

  @Column({ type: 'int', nullable: true })
  currentStep: number;

  @Column({ type: 'int', nullable: true })
  highestStep: number;

  @Column({ nullable: true })
  county: string;

  @Column({ type: 'varchar', enum: Availability, default: Availability.NEGOTIABLE })
  availability: Availability;

  @Column({ nullable: true })
  contractStatus: string;

  @Column({ nullable: true })
  workStatus: string;

  @Column({ default: false })
  hasDrivingLicence: boolean;

  @Column({ default: false })
  hasOwnTransport: boolean;

  @Column({ default: true })
  openToTrials: boolean;

  @Column({ default: true })
  openToMessages: boolean;

  @Column({ default: false })
  openToAgents: boolean;

  @Column({ nullable: true })
  preferredTrainingDays: string;

  @Column({ nullable: true })
  preferredMatchDays: string;

  @Column({ nullable: true })
  medicalNotes: string;

  @Column('simple-array', { nullable: true })
  languagesSpoken: string[];

  @Column('simple-array', { nullable: true })
  lookingForSteps: string[];

  @Column({ default: false })
  isVerifiedPlayer: boolean;

  @Column({ nullable: true })
  lastActiveAt: Date;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  @OneToMany(() => PlayerPosition, (pp) => pp.profile, { cascade: true })
  positions: PlayerPosition[];

  @OneToMany(() => PlayerStatistic, (ps) => ps.profile, { cascade: true })
  statistics: PlayerStatistic[];

  @OneToMany(() => PlayerClubHistory, (ch) => ch.profile, { cascade: true })
  clubHistory: PlayerClubHistory[];

  @OneToMany(() => PlayerVideo, (pv) => pv.profile, { cascade: true })
  videos: PlayerVideo[];
}

export enum Position {
  GK = 'GK', RB = 'RB', CB = 'CB', LB = 'LB',
  RWB = 'RWB', LWB = 'LWB', CDM = 'CDM', CM = 'CM',
  CAM = 'CAM', RM = 'RM', LM = 'LM',
  RW = 'RW', LW = 'LW', ST = 'ST', CF = 'CF',
}

@Entity('player_positions')
export class PlayerPosition {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => PlayerProfile, (profile) => profile.positions)
  @JoinColumn()
  profile: PlayerProfile;

  @Column({ type: 'varchar', enum: Position })
  position: Position;

  @Column({ default: false })
  isPrimary: boolean;
}

@Entity('player_statistics')
export class PlayerStatistic {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => PlayerProfile, (profile) => profile.statistics)
  @JoinColumn()
  profile: PlayerProfile;

  @Column()
  season: string;

  @Column({ default: 0 })
  appearances: number;

  @Column({ default: 0 })
  goals: number;

  @Column({ default: 0 })
  assists: number;

  @Column({ default: 0 })
  cleanSheets: number;

  @Column({ default: 0 })
  minutesPlayed: number;

  @Column({ default: 0 })
  yellowCards: number;

  @Column({ default: 0 })
  redCards: number;
}

@Entity('player_club_history')
export class PlayerClubHistory {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => PlayerProfile, (profile) => profile.clubHistory)
  @JoinColumn()
  profile: PlayerProfile;

  @Column()
  clubName: string;

  @Column()
  years: string;

  @Column({ type: 'int', nullable: true })
  step: number;

  @Column({ nullable: true })
  league: string;
}

@Entity('player_videos')
export class PlayerVideo {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => PlayerProfile, (profile) => profile.videos)
  @JoinColumn()
  profile: PlayerProfile;

  @Column()
  videoUrl: string;

  @Column({ nullable: true })
  thumbnailUrl: string;

  @Column({
    type: 'varchar',
    enum: ['goal', 'skill', 'passing', 'defending', 'goalkeeping', 'training', 'fitness'],
  })
  category: string;

  @Column()
  title: string;

  @CreateDateColumn()
  createdAt: Date;
}


