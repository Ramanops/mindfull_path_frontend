import { Body, Controller, Get, Post, Req } from '@nestjs/common';
import { MoodService } from './mood.service';

@Controller('moods')
export class MoodController {
  constructor(private readonly moodService: MoodService) {}

  // CREATE MOOD
  @Post()
  async createMood(@Req() req: any, @Body() body: any) {
    return this.moodService.createMood(req.user.id, body);
  }

  // GET HISTORY
  @Get('history')
  async history(@Req() req: any) {
    return this.moodService.getHistory(req.user.id);
  }
}
