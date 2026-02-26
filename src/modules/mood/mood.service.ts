import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../prisma.service';

@Injectable()
export class MoodService {
  constructor(private prisma: PrismaService) {}

  async createMood(userId: string, body: any) {
    return this.prisma.moodEntry.create({
      data: {
        userId,
        moodType: body.moodType,
        intensity: body.intensity,
        note: body.note,
      },
    });
  }

  async getHistory(userId: string) {
    return this.prisma.moodEntry.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
    });
  }
}
