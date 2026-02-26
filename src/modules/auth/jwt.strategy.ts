import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { PrismaService } from '../../prisma.service';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(private prisma: PrismaService) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      secretOrKey: process.env.JWT_SECRET as string,
    });
  }

  async validate(payload: { sub: string }) {
    console.log('JWT PAYLOAD =>', payload);

    const user = await this.prisma.user.findUnique({
      where: { id: payload.sub },
    });

    console.log('VALIDATED USER =>', user);

    if (!user) {
      console.log('⚠️ USER NOT FOUND IN DATABASE');
      throw new UnauthorizedException('User no longer exists');
    }

    return user; // This becomes req.user
  }
}