import { Module, MiddlewareConsumer, NestModule } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';

import { AuthModule } from './modules/auth/auth.module';
import { JournalModule } from './modules/journal/journal.module';
import { MoodModule } from './modules/mood/mood.module';
import { StreakModule } from './modules/streak/streak.module';
import { ChatModule } from './modules/chat/chat.module'; // ✅ ADD THIS
import { AnalyticsModule } from './modules/analytics/analytics.module';
import { UserModule } from './modules/user/user.module';


import { authMiddleware } from './middleware/auth.middleware';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true, // loads .env globally
    }),

    AuthModule,
    JournalModule,
    MoodModule,
    StreakModule,
    ChatModule, 
    AnalyticsModule,
     UserModule,// ✅ ADD THIS
  ],
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    consumer.apply(authMiddleware).forRoutes('*');
  }
}