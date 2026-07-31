import { Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Conversation, Message, ConversationStatus, MessageType } from './entities/messaging.entity';
import { User } from '../users/entities/user.entity';

@Injectable()
export class MessagingService {
  constructor(
    @InjectRepository(Conversation)
    private readonly convRepo: Repository<Conversation>,
    @InjectRepository(Message)
    private readonly msgRepo: Repository<Message>,
    @InjectRepository(User)
    private readonly userRepo: Repository<User>,
  ) {}

  async sendInvite(clubId: string, playerId: string, initialMessage?: string) {
    // Check if conversation already exists
    const existing = await this.convRepo.findOne({
      where: [
        { clubId, playerId },
        { clubId: playerId, playerId: clubId },
      ],
    });

    if (existing) {
      throw new ForbiddenException('A conversation invitation already exists');
    }

    const conv = this.convRepo.create({
      clubId,
      playerId,
      status: ConversationStatus.PENDING,
      lastMessageAt: new Date(),
    });

    const saved = await this.convRepo.save(conv);

    if (initialMessage) {
      await this.msgRepo.save({
        conversationId: saved.id,
        senderId: clubId,
        content: initialMessage,
        type: MessageType.TEXT,
      });
    }

    return saved;
  }

  async acceptInvite(convId: string, userId: string) {
    const conv = await this.convRepo.findOne({ where: { id: convId } });
    if (!conv) throw new NotFoundException('Conversation not found');
    if (conv.playerId !== userId) throw new ForbiddenException('Only the player can accept the invite');
    if (conv.status !== ConversationStatus.PENDING) {
      throw new ForbiddenException('Invitation is no longer pending');
    }

    conv.status = ConversationStatus.ACCEPTED;
    conv.lastMessageAt = new Date();
    return this.convRepo.save(conv);
  }

  async rejectInvite(convId: string, userId: string) {
    const conv = await this.convRepo.findOne({ where: { id: convId } });
    if (!conv) throw new NotFoundException('Conversation not found');
    if (conv.playerId !== userId) throw new ForbiddenException('Only the player can reject the invite');

    conv.status = ConversationStatus.REJECTED;
    return this.convRepo.save(conv);
  }

  async getConversations(userId: string) {
    return this.convRepo.find({
      where: [
        { playerId: userId },
        { clubId: userId },
      ],
      relations: { player: true, club: true },
      order: { lastMessageAt: 'DESC' },
    });
  }

  async getConversation(convId: string, userId: string) {
    const conv = await this.convRepo.findOne({
      where: { id: convId },
      relations: { player: true, club: true, messages: { sender: true } },
    });

    if (!conv) throw new NotFoundException('Conversation not found');
    if (conv.playerId !== userId && conv.clubId !== userId) {
      throw new ForbiddenException('Access denied');
    }

    return conv;
  }

  async sendMessage(convId: string, senderId: string, content: string, type: MessageType = MessageType.TEXT) {
    const conv = await this.convRepo.findOne({ where: { id: convId } });

    if (!conv) throw new NotFoundException('Conversation not found');
    if (conv.status !== ConversationStatus.ACCEPTED) {
      throw new ForbiddenException('Messaging is only enabled after the invitation is accepted');
    }
    if (conv.playerId !== senderId && conv.clubId !== senderId) {
      throw new ForbiddenException('You are not a participant in this conversation');
    }

    const msg = this.msgRepo.create({
      conversationId: convId,
      senderId,
      content,
      type,
    });

    await this.convRepo.update(convId, { lastMessageAt: new Date() });
    return this.msgRepo.save(msg);
  }

  async markAsRead(convId: string, userId: string) {
    await this.msgRepo.update(
      { conversationId: convId, senderId: userId, isRead: false },
      { isRead: true, readAt: new Date() },
    );
  }

  async archiveConversation(convId: string, userId: string) {
    const conv = await this.getConversation(convId, userId);
    conv.status = ConversationStatus.ARCHIVED;
    return this.convRepo.save(conv);
  }

  async blockConversation(convId: string, userId: string) {
    const conv = await this.getConversation(convId, userId);
    conv.status = ConversationStatus.BLOCKED;
    return this.convRepo.save(conv);
  }
}
