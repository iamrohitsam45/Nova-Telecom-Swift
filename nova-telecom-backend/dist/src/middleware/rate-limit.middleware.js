"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.rateLimiter = void 0;
const memoryStore = new Map();
const rateLimiter = (options) => {
    return (req, res, next) => {
        const ip = req.ip || req.socket.remoteAddress || 'unknown';
        const now = Date.now();
        const record = memoryStore.get(ip);
        if (!record || now > record.resetTime) {
            memoryStore.set(ip, {
                count: 1,
                resetTime: now + options.windowMs
            });
            res.setHeader('X-RateLimit-Limit', options.maxRequests);
            res.setHeader('X-RateLimit-Remaining', options.maxRequests - 1);
            next();
            return;
        }
        if (record.count >= options.maxRequests) {
            res.setHeader('Retry-After', Math.ceil((record.resetTime - now) / 1000));
            res.status(429).json({
                success: false,
                error: {
                    code: 'RATE_LIMIT_EXCEEDED',
                    message: 'Too many requests. Please slow down and try again shortly.'
                }
            });
            return;
        }
        record.count += 1;
        res.setHeader('X-RateLimit-Limit', options.maxRequests);
        res.setHeader('X-RateLimit-Remaining', options.maxRequests - record.count);
        next();
    };
};
exports.rateLimiter = rateLimiter;
