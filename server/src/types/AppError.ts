export class AppError extends Error {
    statusCode: number;
    isOperational: boolean;

    constructor(message: string, statusCode: number, isOperational: boolean) {
        super(message);
        this.statusCode = statusCode;
        this.isOperational = isOperational;
        Error.captureStackTrace(this, this.constructor);
    }
}

export class NotFoundError extends AppError {
    constructor(message = 'Resource not found.') {
        super(message, 404, true);
    }
}
export class BadRequestError extends AppError {
    constructor(message = 'Invalid request.') {
        super(message, 400, true);
    }
}
export class UnauthorizedError extends AppError {
    constructor(message = 'Unauthorized. You don\'t have permission to access this resource.') {
        super(message, 401, true);
    }
}
export class ForbiddenError extends AppError {
    constructor(message = 'Forbidden access.') {
        super(message, 403, true);
    }
}
export class InternalServerError extends AppError {
    constructor(message = 'Internal server error.') {
        super(message, 500, false);
    }
}
export class ConflictError extends AppError {
    constructor(message = 'Conflict error.') {
        super(message, 409, true);
    }
}
export class NotImplementedError extends AppError {
    constructor(message = 'This feature is not implemented yet.') {
        super(message, 501, false);
    }
}
export class ServiceUnavailableError extends AppError {
    constructor(message = 'Service unavailable. Please try again later.') {
        super(message, 503, false);
    }
}
export class GatewayTimeoutError extends AppError {
    constructor(message = 'Gateway timeout. Please try again later.') {
        super(message, 504, false);
    }
}
export class TooManyRequestsError extends AppError {
    constructor(message = 'Too many requests. Please try again later.') {
        super(message, 429, true);
    }
}