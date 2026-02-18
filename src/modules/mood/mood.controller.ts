import { Body, Controller, Get, Post, Req } from '@nestjs/common';
import { PrismaService } from '../../prisma.service';
import { redis } from '../../config/redis';

@Controller('moods')
export class MoodController {
  constructor(private prisma: PrismaService) {}

  // CREATE MOOD
  @Post()
  async create(@Req() req, @Body() body) {
    const newMood = await this.prisma.moodEntry.create({
      data: {
        userId: req.user.id,
        moodType: body.moodType,
        intensity: body.intensity,
        note: body.note,
      },
    });

    // 🧹 clear cached history after new entry
    await redis.del(`moods:${req.user.id}`);

    return newMood;
  }

  // GET HISTORY (cached)
  @Get('history')
  async history(@Req() req) {
    const key = `moods:${req.user.id}`;

    // 1️⃣ Check Redis cache
    const cached = await redis.get(key);
    if (cached) {
      console.log('Serving moods from cache');
      return cached;
    }

    // 2️⃣ Fetch from DB
    const data = await this.prisma.moodEntry.findMany({
      where: { userId: req.user.id },
      orderBy: { createdAt: 'desc' },
    });

    // 3️⃣ Store in cache (60 seconds)
    await redis.set(key, data, { ex: 60 });

    return data;
  }
}
