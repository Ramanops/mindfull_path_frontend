import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../prisma.service';

@Injectable()
export class JournalService {
  constructor(private prisma: PrismaService) {}

  // ---------------- CREATE ENTRY ----------------
  async create(userId: string, content: string, moodTag?: string) {
    return this.prisma.journalEntry.create({
      data: {
        userId, // ✅ UUID string
        content,
        moodTag,
      },
    });
  }

  // ---------------- GET USER JOURNAL ----------------
  async getByUser(userId: string) {
    return this.prisma.journalEntry.findMany({
      where: {
        userId, // ✅ UUID string
      },
      orderBy: {
        createdAt: 'desc',
      },
    });
  }
}