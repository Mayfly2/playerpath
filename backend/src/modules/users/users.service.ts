import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './entities/user.entity';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private readonly userRepo: Repository<User>,
  ) {}

  async findById(id: string): Promise<User> {
    const user = await this.userRepo.findOne({
      where: { id },
      relations: { playerProfile: true, clubProfile: true },
    });
    if (!user) throw new NotFoundException('User not found');
    return user;
  }

  async update(id: string, data: Partial<User>): Promise<User> {
    await this.userRepo.update(id, data);
    return this.findById(id);
  }

  async delete(id: string): Promise<void> {
    await this.userRepo.update(id, { isActive: false });
  }

  async hardDelete(id: string): Promise<void> {
    await this.userRepo.delete(id);
  }

  async exportData(id: string): Promise<User | null> {
    return this.userRepo.findOne({
      where: { id },
      relations: { playerProfile: true, clubProfile: true },
    });
  }
}
