import { ErrorRequestHandler } from 'express';
import { AppError } from '../types/AppError';

export const errorHandler: ErrorRequestHandler = (err, req, res, next) => {
  // Si es un error de negocio que extendiste de AppError:
  if (err instanceof AppError) {
    if (process.env.NODE_ENV !== 'test') {
      console.error(err);
    }
    res.status(err.statusCode).json({
      success: false,
      error: err.message,
      ...(process.env.NODE_ENV === 'development' && { stack: err.stack }),
    });
    return;
  }

  // Si es cualquier otro error no manejado:
  if (process.env.NODE_ENV !== 'test') {
    console.error(err);
  }
  res.status(500).json({
    success: false,
    error: 'Internal Server Error',
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack, details: err.message }),
  });
};