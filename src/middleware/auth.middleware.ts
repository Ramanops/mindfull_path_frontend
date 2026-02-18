import { Request, Response, NextFunction } from 'express';
import * as jwt from 'jsonwebtoken';
import { httpRequests } from '../config/metrics';

// Extend Express Request type
declare module 'express-serve-static-core' {
  interface Request {
    user?: { id: string };
  }
}

// 🔐 Auth + 📊 Metrics together
export function authMiddleware(req: Request, res: Response, next: NextFunction) {
  // metrics count every request
  httpRequests.inc();

  const authHeader = req.headers.authorization;
  const token = authHeader?.split(' ')[1];

  if (!token) {
    return res.status(401).json({ message: 'Unauthorized: No token' });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET as string) as any;

    // attach user to request
    req.user = { id: decoded.sub };

    next();
  } catch (err) {
    return res.status(401).json({ message: 'Invalid token' });
  }
}
