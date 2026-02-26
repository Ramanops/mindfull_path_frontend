import {
  Body,
  Controller,
  Get,
  Post,
  Req,
  UseGuards,
  UnauthorizedException,
} from '@nestjs/common';
import { Request } from 'express';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { JournalService } from './journal.service';

@Controller('journal')
@UseGuards(JwtAuthGuard) // 🔐 Protect ALL routes in this controller
export class JournalController {
  constructor(private readonly journalService: JournalService) {}

  @Post()
  async create(
    @Req() req: Request & { user: any },
    @Body() body: { content: string; moodTag?: string },
  ) {
    if (!req.user) {
      throw new UnauthorizedException('User not authenticated');
    }

    return this.journalService.create(
      req.user.id,
      body.content,
      body.moodTag,
    );
  }

  @Get()
  async getUserJournal(@Req() req: Request & { user: any }) {
    if (!req.user) {
      throw new UnauthorizedException('User not authenticated');
    }

    return this.journalService.getByUser(req.user.id);
  }
}