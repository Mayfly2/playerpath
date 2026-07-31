import { Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { PlayerProfile, PlayerPosition, PlayerStatistic, PlayerClubHistory, PlayerVideo } from './entities/player-profile.entity';
import { CreatePlayerProfileDto, AddPositionDto, AddStatisticDto, AddClubHistoryDto } from './dto/player-profile.dto';
import { User } from '../users/entities/user.entity';

@Injectable()
export class PlayersService {
  constructor(
    @InjectRepository(PlayerProfile)
    private readonly profileRepo: Repository<PlayerProfile>,
    @InjectRepository(PlayerPosition)
    private readonly positionRepo: Repository<PlayerPosition>,
    @InjectRepository(PlayerStatistic)
    private readonly statisticRepo: Repository<PlayerStatistic>,
    @InjectRepository(PlayerClubHistory)
    private readonly clubHistoryRepo: Repository<PlayerClubHistory>,
    @InjectRepository(PlayerVideo)
    private readonly videoRepo: Repository<PlayerVideo>,
    @InjectRepository(User)
    private readonly userRepo: Repository<User>,
  ) {}

  async createProfile(userId: string, dto: CreatePlayerProfileDto) {
    const user = await this.userRepo.findOne({ where: { id: userId } });
    if (!user) throw new NotFoundException('User not found');

    const existing = await this.profileRepo.findOne({ where: { user: { id: userId } } });
    if (existing) throw new ForbiddenException('Profile already exists');

    const profile = this.profileRepo.create({ ...dto, user });
    return this.profileRepo.save(profile);
  }

  async getOwnProfile(userId: string) {
    const profile = await this.profileRepo.findOne({
      where: { user: { id: userId } },
      relations: { positions: true, statistics: true, clubHistory: true, videos: true },
    });
    if (!profile) throw new NotFoundException('Profile not found');
    return profile;
  }

  async updateProfile(userId: string, dto: CreatePlayerProfileDto) {
    const profile = await this.profileRepo.findOne({ where: { user: { id: userId } } });
    if (!profile) throw new NotFoundException('Profile not found');
    await this.profileRepo.update(profile.id, dto);
    return this.getOwnProfile(userId);
  }

  async getPublicProfile(profileId: string) {
    const profile = await this.profileRepo.findOne({
      where: { id: profileId },
      relations: { positions: true, statistics: true, clubHistory: true, videos: true },
    });
    if (!profile) throw new NotFoundException('Player not found');
    return profile;
  }

  // Positions
  async addPosition(userId: string, dto: AddPositionDto) {
    const profile = await this.profileRepo.findOne({ where: { user: { id: userId } } });
    if (!profile) throw new NotFoundException('Profile not found');
    const pos = this.positionRepo.create({ ...dto, profile });
    return this.positionRepo.save(pos);
  }

  async updatePositions(userId: string, positions: AddPositionDto[]) {
    const profile = await this.profileRepo.findOne({ where: { user: { id: userId } } });
    if (!profile) throw new NotFoundException('Profile not found');
    await this.positionRepo.delete({ profile: { id: profile.id } });
    const newPositions = positions.map((p) => this.positionRepo.create({ ...p, profile }));
    return this.positionRepo.save(newPositions);
  }

  // Statistics
  async addStatistic(userId: string, dto: AddStatisticDto) {
    const profile = await this.profileRepo.findOne({ where: { user: { id: userId } } });
    if (!profile) throw new NotFoundException('Profile not found');
    const stat = this.statisticRepo.create({ ...dto, profile });
    return this.statisticRepo.save(stat);
  }

  async deleteStatistic(userId: string, statId: string) {
    const profile = await this.profileRepo.findOne({ where: { user: { id: userId } } });
    if (!profile) throw new NotFoundException('Profile not found');
    await this.statisticRepo.delete({ id: statId, profile: { id: profile.id } });
    return { message: 'Statistic removed' };
  }

  // Club History
  async addClubHistory(userId: string, dto: AddClubHistoryDto) {
    const profile = await this.profileRepo.findOne({ where: { user: { id: userId } } });
    if (!profile) throw new NotFoundException('Profile not found');
    const history = this.clubHistoryRepo.create({ ...dto, profile });
    return this.clubHistoryRepo.save(history);
  }

  async deleteClubHistory(userId: string, historyId: string) {
    const profile = await this.profileRepo.findOne({ where: { user: { id: userId } } });
    if (!profile) throw new NotFoundException('Profile not found');
    await this.clubHistoryRepo.delete({ id: historyId, profile: { id: profile.id } });
    return { message: 'Club history removed' };
  }
}
