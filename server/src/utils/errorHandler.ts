import { Request, Response, NextFunction } from 'express';

export function errorHandler(
  err: any,
  req: Request,
  res: Response,
  next: NextFunction
) {
  // Set default status and message
  const status = err.status || 500;
  const message = err.message || 'Internal Server Error';

  // Log the error (puedes mejorarlo para logging avanzado)
  if (process.env.NODE_ENV !== 'test') {
    console.error(err);
  }

  res.status(status).json({
    success: false,
    error: message,
    // Opcional: incluye detalles solo en desarrollo
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack }),
  });
}