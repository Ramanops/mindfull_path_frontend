import { NestFactory } from '@nestjs/core';
import helmet from 'helmet';
import cookieParser from 'cookie-parser';
import { AppModule } from './app.module';
import { SentryFilter } from './common/sentry.filter';   // 👈 add this

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  app.use(helmet());
  app.use(cookieParser());

  // 👇 register global error handler
  app.useGlobalFilters(new SentryFilter());

  await app.listen(3000);
}
bootstrap();
