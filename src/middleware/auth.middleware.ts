import { Request, Response, NextFunction } from 'express';
import * as jwt from 'jsonwebtoken';
import { httpRequests } from '../config/metrics';

declare module 'express-serve-static-core' {
  interface Request {
    user?: { id: string };
  }
}

export function authMiddleware(req: Request, res: Response, next: NextFunction) {
  httpRequests.inc();

  // 🔴 USE originalUrl — NOT path
  const url = req.originalUrl;

  // PUBLIC ROUTES
  if (
    url.includes('/auth/register') ||
    url.includes('/auth/login')
  ) {
    return next();
  }

  // TOKEN CHECK
  const authHeader = req.headers.authorization;
  const token = authHeader?.split(' ')[1];

  if (!token) {
    return res.status(401).json({ message: 'Unauthorized: No token' });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET as string) as any;
    req.user = { id: decoded.sub };
    next();

  } catch {
    return res.status(401).json({ message: 'Invalid token' });
  }
}
