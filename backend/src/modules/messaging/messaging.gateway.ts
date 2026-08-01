import {
  WebSocketGateway, WebSocketServer, SubscribeMessage,
  OnGatewayConnection, OnGatewayDisconnect, ConnectedSocket, MessageBody,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { Logger, UseGuards } from '@nestjs/common';
import { WsJwtGuard } from '../../common/guards/ws-jwt.guard';

@WebSocketGateway({
  cors: { origin: '*', credentials: true },
  namespace: 'messaging',
})
export class MessagingGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer()
  server: Server;

  private readonly logger = new Logger(MessagingGateway.name);
  private onlineUsers = new Map<string, Set<string>>(); // userId → Set<socketId>

  handleConnection(client: Socket) {
    this.logger.log(`Client connected: ${client.id}`);
  }

  handleDisconnect(client: Socket) {
    // Remove from all user mappings
    for (const [userId, sockets] of this.onlineUsers.entries()) {
      sockets.delete(client.id);
      if (sockets.size === 0) this.onlineUsers.delete(userId);
    }
    this.logger.log(`Client disconnected: ${client.id}`);
  }

  @UseGuards(WsJwtGuard)
  @SubscribeMessage('auth:register')
  handleRegister(@ConnectedSocket() client: Socket, @MessageBody() data: { userId: string }) {
    if (!this.onlineUsers.has(data.userId)) {
      this.onlineUsers.set(data.userId, new Set());
    }
    this.onlineUsers.get(data.userId)!.add(client.id);
    this.logger.log(`User ${data.userId} registered on socket ${client.id}`);
  }

  @UseGuards(WsJwtGuard)
  @SubscribeMessage('message:send')
  handleMessage(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { conversationId: string; content: string; type?: string },
  ) {
    // Broadcast to all clients in the conversation room
    this.server.to(`conversation:${data.conversationId}`).emit('message:new', {
      conversationId: data.conversationId,
      content: data.content,
      type: data.type || 'text',
      createdAt: new Date().toISOString(),
    });
  }

  @UseGuards(WsJwtGuard)
  @SubscribeMessage('conversation:join')
  handleJoinConversation(@ConnectedSocket() client: Socket, @MessageBody() data: { conversationId: string }) {
    client.join(`conversation:${data.conversationId}`);
    this.logger.log(`Socket ${client.id} joined conversation ${data.conversationId}`);
  }

  @UseGuards(WsJwtGuard)
  @SubscribeMessage('conversation:leave')
  handleLeaveConversation(@ConnectedSocket() client: Socket, @MessageBody() data: { conversationId: string }) {
    client.leave(`conversation:${data.conversationId}`);
  }

  @UseGuards(WsJwtGuard)
  @SubscribeMessage('typing:start')
  handleTypingStart(@ConnectedSocket() client: Socket, @MessageBody() data: { conversationId: string; userId: string }) {
    client.to(`conversation:${data.conversationId}`).emit('typing:update', {
      conversationId: data.conversationId,
      userId: data.userId,
      isTyping: true,
    });
  }

  @UseGuards(WsJwtGuard)
  @SubscribeMessage('typing:stop')
  handleTypingStop(@ConnectedSocket() client: Socket, @MessageBody() data: { conversationId: string; userId: string }) {
    client.to(`conversation:${data.conversationId}`).emit('typing:update', {
      conversationId: data.conversationId,
      userId: data.userId,
      isTyping: false,
    });
  }

  // Server-side emit helpers for use by services
  sendToUser(userId: string, event: string, data: any) {
    const sockets = this.onlineUsers.get(userId);
    if (sockets) {
      for (const socketId of sockets) {
        this.server.to(socketId).emit(event, data);
      }
    }
  }

  sendToConversation(conversationId: string, event: string, data: any) {
    this.server.to(`conversation:${conversationId}`).emit(event, data);
  }
}
