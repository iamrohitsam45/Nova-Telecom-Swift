import { Request, Response, NextFunction } from 'express';
import { ZodError } from 'zod';

export interface AppErrorPayload {
  code: string;
  message: string;
  details?: unknown;
}

export class AppError extends Error {
  public statusCode: number;
  public code: string;
  public details?: unknown;

  constructor(statusCode: number, code: string, message: string, details?: unknown) {
    super(message);
    this.statusCode = statusCode;
    this.code = code;
    this.details = details;
    Object.setPrototypeOf(this, AppError.prototype);
  }
}

export const errorHandler = (err: unknown, req: Request, res: Response, next: NextFunction): void => {
  if (err instanceof AppError) {
    res.status(err.statusCode).json({
      success: false,
      error: {
        code: err.code,
        message: err.message,
        details: err.details
      }
    });
    return;
  }

  if (err instanceof ZodError) {
    res.status(400).json({
      success: false,
      error: {
        code: 'VALIDATION_ERROR',
        message: 'Invalid request body or parameters',
        details: (err as any).errors || (err as any).issues || err.message
      }
    });
    return;
  }

  const errorObj = err as Error;
  console.error('[UNCAUGHT SERVER ERROR]', errorObj.stack || errorObj.message);

  res.status(500).json({
    success: false,
    error: {
      code: 'INTERNAL_SERVER_ERROR',
      message: 'An unexpected internal error occurred on the telecom gateway.'
    }
  });
};
