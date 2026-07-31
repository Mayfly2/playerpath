import { Controller, Get, Patch, Delete, Body, UseGuards } from '@nestjs/common';
import { UsersService } from './users.service';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { CurrentUser } from '../../common/decorators/current-user.decorator';

@Controller('users')
@UseGuards(JwtAuthGuard)
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get('me')
  async getMe(@CurrentUser() user: any) {
    return this.usersService.findById(user.id);
  }

  @Patch('me')
  async updateMe(@CurrentUser() user: any, @Body() data: any) {
    return this.usersService.update(user.id, data);
  }

  @Delete('me')
  async deleteMe(@CurrentUser() user: any) {
    await this.usersService.delete(user.id);
    return { message: 'Account deactivated' };
  }

  @Get('me/export')
  async exportData(@CurrentUser() user: any) {
    return this.usersService.exportData(user.id);
  }
}
