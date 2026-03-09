import { NestFactory } from '@nestjs/core';
import helmet from 'helmet';
import cookieParser from 'cookie-parser';
import { AppModule } from './app.module';
import { SentryFilter } from './common/sentry.filter';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // ⭐ Enable CORS
  app.enableCors({
    origin: true,
    credentials: true,
  });

  // ⭐ Global API prefix
  app.setGlobalPrefix('api');

  // security middleware
  app.use(helmet());
  app.use(cookieParser());

  // global error handler
  app.useGlobalFilters(new SentryFilter());

  // ✅ Listen on 0.0.0.0 so physical devices on same WiFi can connect
  await app.listen(3000, '0.0.0.0');
  console.log(`🚀 Server running on http://10.21.8.78:3000`);
}
bootstrap();