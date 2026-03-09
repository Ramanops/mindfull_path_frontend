import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../prisma.service';

@Injectable()
export class AnalyticsService {
  constructor(private prisma: PrismaService) {}

  async getSummary(userId: string, days: number = 7) {
    const since = new Date();
    since.setDate(since.getDate() - days);

    // ── Mood entries in range ──────────────────────────
    const moods = await this.prisma.moodEntry.findMany({
      where: { userId, createdAt: { gte: since } },
      orderBy: { createdAt: 'asc' },
    });

    // Daily mood intensities for line chart
    const moodTimeline = this.buildDailyTimeline(moods, days);

    // Mood type distribution for donut chart
    const moodBreakdown = moods.reduce((acc: any, m) => {
      acc[m.moodType] = (acc[m.moodType] || 0) + 1;
      return acc;
    }, {});

    // ── Journal entries in range ───────────────────────
    const journals = await this.prisma.journalEntry.findMany({
      where: { userId, createdAt: { gte: since } },
      orderBy: { createdAt: 'asc' },
    });
    const journalActivity = this.buildJournalActivity(journals, days);

    // ── Streak info ────────────────────────────────────
    const streak = await this.prisma.streak.findUnique({
      where: { userId },
    });

    return {
      moodTimeline,
      moodBreakdown,
      journalActivity,
      totalMoodEntries: moods.length,
      totalJournalEntries: journals.length,
      avgMoodIntensity: moods.length
        ? +(moods.reduce((s, m) => s + m.intensity, 0) / moods.length).toFixed(1)
        : 0,
      currentStreak: streak?.currentStreak ?? 0,
      longestStreak: streak?.longestStreak ?? 0,
    };
  }

  private buildDailyTimeline(moods: any[], days: number) {
    const map: Record<string, { sum: number; count: number }> = {};
    moods.forEach((m) => {
      const key = m.createdAt.toISOString().split('T')[0];
      if (!map[key]) map[key] = { sum: 0, count: 0 };
      map[key].sum += m.intensity;
      map[key].count++;
    });

    return Array.from({ length: days }, (_, i) => {
      const d = new Date();
      d.setDate(d.getDate() - (days - 1 - i));
      const key = d.toISOString().split('T')[0];
      const entry = map[key];
      return {
        date: key,
        avgIntensity: entry ? +(entry.sum / entry.count).toFixed(1) : null,
      };
    });
  }

  private buildJournalActivity(journals: any[], days: number) {
    const map: Record<string, number> = {};
    journals.forEach((j) => {
      const key = j.createdAt.toISOString().split('T')[0];
      map[key] = (map[key] || 0) + 1;
    });
    return Array.from({ length: days }, (_, i) => {
      const d = new Date();
      d.setDate(d.getDate() - (days - 1 - i));
      const key = d.toISOString().split('T')[0];
      return { date: key, count: map[key] ?? 0 };
    });
  }
}
