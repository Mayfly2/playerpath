import { Injectable, CanActivate, ExecutionContext } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';

@Injectable()
export class WsJwtGuard implements CanActivate {
  constructor(private readonly jwtService: JwtService) {}

  canActivate(context: ExecutionContext): boolean {
    const client = context.switchToWs().getClient();
    const token = this.extractToken(client);

    if (!token) return false;

    try {
      const payload = this.jwtService.verify(token);
      client.user = payload;
      return true;
    } catch {
      return false;
    }
  }

  private extractToken(client: any): string | null {
    const auth = client.handshake?.auth?.token
      || client.handshake?.headers?.authorization
      || client.handshake?.query?.token;

    if (!auth) return null;
    if (auth.startsWith('Bearer ')) return auth.substring(7);
    return auth;
  }
}
