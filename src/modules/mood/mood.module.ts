import { Module } from '@nestjs/common';
import { MoodController } from './mood.controller';
import { MoodService } from './mood.service';
import { PrismaService } from '../../prisma.service';

@Module({
  controllers: [MoodController],
  providers: [MoodService, PrismaService],
})
export class MoodModule {}
