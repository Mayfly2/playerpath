import { Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ClubProfile } from './entities/club-profile.entity';
import { CreateClubProfileDto } from './dto/club-profile.dto';
import { User } from '../users/entities/user.entity';

@Injectable()
export class ClubsService {
  constructor(
    @InjectRepository(ClubProfile)
    private readonly profileRepo: Repository<ClubProfile>,
    @InjectRepository(User)
    private readonly userRepo: Repository<User>,
  ) {}

  async createProfile(userId: string, dto: CreateClubProfileDto) {
    const user = await this.userRepo.findOne({ where: { id: userId } });
    if (!user) throw new NotFoundException('User not found');

    const existing = await this.profileRepo.findOne({ where: { user: { id: userId } } });
    if (existing) throw new ForbiddenException('Club profile already exists');

    const profile = this.profileRepo.create({ ...dto, user });
    return this.profileRepo.save(profile);
  }

  async getOwnProfile(userId: string) {
    const profile = await this.profileRepo.findOne({ where: { user: { id: userId } } });
    if (!profile) throw new NotFoundException('Club profile not found');
    return profile;
  }

  async updateProfile(userId: string, dto: CreateClubProfileDto) {
    const profile = await this.profileRepo.findOne({ where: { user: { id: userId } } });
    if (!profile) throw new NotFoundException('Club profile not found');
    await this.profileRepo.update(profile.id, dto);
    return this.getOwnProfile(userId);
  }

  async getPublicProfile(profileId: string) {
    const profile = await this.profileRepo.findOne({ where: { id: profileId } });
    if (!profile) throw new NotFoundException('Club not found');
    return profile;
  }
}
