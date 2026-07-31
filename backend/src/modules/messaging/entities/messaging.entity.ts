import {
  Entity, PrimaryGeneratedColumn, Column, CreateDateColumn,
  ManyToOne, JoinColumn, OneToMany,
} from 'typeorm';
import { User } from '../../users/entities/user.entity';

export enum ConversationStatus {
  PENDING = 'pending',
  ACCEPTED = 'accepted',
  REJECTED = 'rejected',
  BLOCKED = 'blocked',
  ARCHIVED = 'archived',
}

export enum MessageType {
  TEXT = 'text',
  IMAGE = 'image',
  VIDEO = 'video',
  PDF = 'pdf',
  TRIAL_INVITE = 'trial_invite',
}

@Entity('conversations')
export class Conversation {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => User)
  @JoinColumn()
  player: User;

  @Column()
  playerId: string;

  @ManyToOne(() => User)
  @JoinColumn()
  club: User;

  @Column()
  clubId: string;

  @Column({ type: 'varchar', enum: ConversationStatus, default: ConversationStatus.PENDING })
  status: ConversationStatus;

  @Column({ nullable: true })
  lastMessageAt: Date;

  @CreateDateColumn()
  createdAt: Date;

  @OneToMany(() => Message, (msg) => msg.conversation)
  messages: Message[];
}

@Entity('messages')
export class Message {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => Conversation, (conv) => conv.messages)
  @JoinColumn()
  conversation: Conversation;

  @Column()
  conversationId: string;

  @ManyToOne(() => User)
  @JoinColumn()
  sender: User;

  @Column()
  senderId: string;

  @Column({ type: 'text' })
  content: string;

  @Column({ type: 'varchar', enum: MessageType, default: MessageType.TEXT })
  type: MessageType;

  @Column({ nullable: true })
  mediaUrl: string;

  @Column({ default: false })
  isRead: boolean;

  @Column({ nullable: true })
  readAt: Date;

  @CreateDateColumn()
  createdAt: Date;
}

@Entity('trial_invitations')
export class TrialInvitation {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => User)
  @JoinColumn()
  club: User;

  @Column()
  clubId: string;

  @ManyToOne(() => User)
  @JoinColumn()
  player: User;

  @Column()
  playerId: string;

  @Column({ type: 'varchar', enum: ['training', 'trial', 'friendly'] })
  type: string;

  @Column({ type: 'date' })
  proposedDate: Date;

  @Column({ type: 'varchar', enum: ['pending', 'accepted', 'declined', 'rescheduled'], default: 'pending' })
  status: string;

  @Column({ type: 'text', nullable: true })
  notes: string;

  @Column({ type: 'date', nullable: true })
  suggestedDate: Date;

  @CreateDateColumn()
  createdAt: Date;
}
