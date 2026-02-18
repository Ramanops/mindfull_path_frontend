import { Injectable, UnauthorizedException, ConflictException } from '@nestjs/common';
import * as bcrypt from 'bcrypt';
import * as jwt from 'jsonwebtoken';
import { PrismaService } from '../../prisma.service';

@Injectable()
export class AuthService {
  constructor(private prisma: PrismaService) {}

  // ---------------- REGISTER ----------------
  async register(name: string, email: string, password: string) {
    // check if email already exists
    const existing = await this.prisma.user.findUnique({
      where: { email },
    });

    if (existing) {
      throw new ConflictException('Email already registered');
    }

    // hash password
    const hash = await bcrypt.hash(password, 10);

    const user = await this.prisma.user.create({
      data: {
        name,
        email,
        passwordHash: hash,
      },
    });

    // never return password hash
    return {
      id: user.id,
      name: user.name,
      email: user.email,
      createdAt: user.createdAt,
    };
  }

  // ---------------- LOGIN ----------------
  async login(email: string, password: string) {
    const user = await this.prisma.user.findUnique({
      where: { email },
    });

    if (!user) {
      throw new UnauthorizedException('User not found');
    }

    const valid = await bcrypt.compare(password, user.passwordHash);

    if (!valid) {
      throw new UnauthorizedException('Invalid password');
    }

    // create JWT token (7 days)
    const token = jwt.sign(
      { sub: user.id },
      process.env.JWT_SECRET as string,
      { expiresIn: '7d' },
    );

    return {
      token,
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
      },
    };
  }
}
