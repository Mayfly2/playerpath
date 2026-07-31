import {
  Controller, Get, Post, Patch, Body, Param, UseGuards,
} from '@nestjs/common';
import { MessagingService } from './messaging.service';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { CurrentUser } from '../../common/decorators/current-user.decorator';

@Controller('messaging')
@UseGuards(JwtAuthGuard)
export class MessagingController {
  constructor(private readonly messagingService: MessagingService) {}

  @Post('invite')
  async sendInvite(
    @CurrentUser() user: any,
    @Body() body: { playerId: string; message?: string },
  ) {
    return this.messagingService.sendInvite(user.id, body.playerId, body.message);
  }

  @Post('invite/:id/accept')
  async acceptInvite(@CurrentUser() user: any, @Param('id') id: string) {
    return this.messagingService.acceptInvite(id, user.id);
  }

  @Post('invite/:id/reject')
  async rejectInvite(@CurrentUser() user: any, @Param('id') id: string) {
    return this.messagingService.rejectInvite(id, user.id);
  }

  @Get('conversations')
  async getConversations(@CurrentUser() user: any) {
    return this.messagingService.getConversations(user.id);
  }

  @Get('conversations/:id')
  async getConversation(@CurrentUser() user: any, @Param('id') id: string) {
    return this.messagingService.getConversation(id, user.id);
  }

  @Post('conversations/:id/messages')
  async sendMessage(
    @CurrentUser() user: any,
    @Param('id') id: string,
    @Body() body: { content: string; type?: string },
  ) {
    return this.messagingService.sendMessage(id, user.id, body.content, body.type as any);
  }

  @Patch('conversations/:id/read')
  async markAsRead(@CurrentUser() user: any, @Param('id') id: string) {
    await this.messagingService.markAsRead(id, user.id);
    return { message: 'Marked as read' };
  }

  @Post('conversations/:id/archive')
  async archive(@CurrentUser() user: any, @Param('id') id: string) {
    return this.messagingService.archiveConversation(id, user.id);
  }

  @Post('conversations/:id/block')
  async block(@CurrentUser() user: any, @Param('id') id: string) {
    return this.messagingService.blockConversation(id, user.id);
  }
}
