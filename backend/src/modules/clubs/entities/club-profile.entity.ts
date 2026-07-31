import {
  Entity, PrimaryGeneratedColumn, Column, CreateDateColumn,
  UpdateDateColumn, OneToOne, JoinColumn,
} from 'typeorm';
import { User } from '../../users/entities/user.entity';

@Entity('club_profiles')
export class ClubProfile {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @OneToOne(() => User, (user) => user.clubProfile)
  @JoinColumn()
  user: User;

  @Column({ nullable: true })
  badgeUrl: string;

  @Column({ nullable: true })
  bannerUrl: string;

  @Column()
  clubName: string;

  @Column({ nullable: true })
  league: string;

  @Column({ type: 'int', nullable: true })
  step: number;

  @Column({ nullable: true })
  ground: string;

  @Column({ nullable: true })
  managerName: string;

  @Column({ nullable: true })
  assistantManagerName: string;

  @Column({ type: 'decimal', precision: 10, scale: 7, nullable: true })
  locationLat: number;

  @Column({ type: 'decimal', precision: 10, scale: 7, nullable: true })
  locationLng: number;

  @Column({ type: 'text', nullable: true })
  description: string;

  @Column({ type: 'text', nullable: true })
  philosophy: string;

  @Column({ type: 'text', nullable: true })
  facilities: string;

  @Column({ nullable: true })
  website: string;

  @Column({ nullable: true })
  facebookUrl: string;

  @Column({ nullable: true })
  twitterUrl: string;

  @Column({ nullable: true })
  instagramUrl: string;

  @Column({ nullable: true })
  contactEmail: string;

  @Column({ nullable: true })
  contactPhone: string;

  @Column({ nullable: true })
  trainingDays: string;

  @Column({ nullable: true })
  matchDays: string;

  @Column({ type: 'int', default: 0 })
  playersWanted: number;

  @Column({ nullable: true })
  budget: string;

  @Column({ default: false })
  hasOpenTrials: boolean;

  @Column({ nullable: true })
  upcomingFixtures: string;

  @Column({ default: false })
  isVerifiedClub: boolean;

  @Column({ default: true })
  isActive: boolean;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
