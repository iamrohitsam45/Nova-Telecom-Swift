"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.authRouter = void 0;
const express_1 = require("express");
const bcryptjs_1 = __importDefault(require("bcryptjs"));
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const crypto_1 = __importDefault(require("crypto"));
const uuidv4 = () => crypto_1.default.randomUUID();
const zod_1 = require("zod");
const env_1 = require("../../config/env");
const store_service_1 = require("../../services/store.service");
const auth_middleware_1 = require("../../middleware/auth.middleware");
exports.authRouter = (0, express_1.Router)();
const store = store_service_1.StoreService.getInstance();
const registerSchema = zod_1.z.object({
    email: zod_1.z.string().email(),
    password: zod_1.z.string().min(6),
    fullName: zod_1.z.string().min(2),
    phoneNumber: zod_1.z.string().min(7)
});
const loginSchema = zod_1.z.object({
    email: zod_1.z.string().email(),
    password: zod_1.z.string().min(1)
});
// POST /auth/register
exports.authRouter.post('/auth/register', async (req, res) => {
    const data = registerSchema.parse(req.body);
    const existing = store.users.find((u) => u.email.toLowerCase() === data.email.toLowerCase());
    if (existing) {
        res.status(409).json({
            success: false,
            error: { code: 'EMAIL_ALREADY_REGISTERED', message: 'An account with this email address already exists.' }
        });
        return;
    }
    const passwordHash = await bcryptjs_1.default.hash(data.password, 10);
    const newUser = {
        id: `usr_${uuidv4().substring(0, 8)}`,
        email: data.email.toLowerCase(),
        passwordHash,
        fullName: data.fullName,
        phoneNumber: data.phoneNumber,
        role: 'CUSTOMER',
        customerSince: new Date().toISOString()
    };
    store.users.push(newUser);
    const accessToken = jsonwebtoken_1.default.sign({ userId: newUser.id, email: newUser.email, role: newUser.role }, env_1.env.JWT_SECRET, { expiresIn: '15m' });
    const refreshToken = `rft_${uuidv4()}`;
    store.refreshTokens.set(refreshToken, newUser.id);
    res.status(201).json({
        success: true,
        data: {
            user: {
                id: newUser.id,
                email: newUser.email,
                fullName: newUser.fullName,
                phoneNumber: newUser.phoneNumber,
                role: newUser.role,
                customerSince: newUser.customerSince
            },
            accessToken,
            refreshToken
        }
    });
});
// POST /auth/login
exports.authRouter.post('/auth/login', async (req, res) => {
    const data = loginSchema.parse(req.body);
    const user = store.users.find((u) => u.email.toLowerCase() === data.email.toLowerCase());
    if (!user || !(await bcryptjs_1.default.compare(data.password, user.passwordHash))) {
        res.status(401).json({
            success: false,
            error: { code: 'INVALID_CREDENTIALS', message: 'Invalid email or password.' }
        });
        return;
    }
    const accessToken = jsonwebtoken_1.default.sign({ userId: user.id, email: user.email, role: user.role }, env_1.env.JWT_SECRET, { expiresIn: '15m' });
    const refreshToken = `rft_${uuidv4()}`;
    store.refreshTokens.set(refreshToken, user.id);
    res.status(200).json({
        success: true,
        data: {
            user: {
                id: user.id,
                email: user.email,
                fullName: user.fullName,
                phoneNumber: user.phoneNumber,
                role: user.role,
                customerSince: user.customerSince
            },
            accessToken,
            refreshToken
        }
    });
});
// POST /auth/refresh
exports.authRouter.post('/auth/refresh', (req, res) => {
    const { refreshToken } = req.body;
    if (!refreshToken || !store.refreshTokens.has(refreshToken)) {
        res.status(401).json({
            success: false,
            error: { code: 'INVALID_REFRESH_TOKEN', message: 'Refresh token is expired, revoked, or invalid' }
        });
        return;
    }
    const userId = store.refreshTokens.get(refreshToken);
    const user = store.users.find((u) => u.id === userId);
    if (!user) {
        res.status(401).json({
            success: false,
            error: { code: 'USER_NOT_FOUND', message: 'User belonging to session no longer exists' }
        });
        return;
    }
    // Rotate refresh token
    store.refreshTokens.delete(refreshToken);
    const newRefreshToken = `rft_${uuidv4()}`;
    store.refreshTokens.set(newRefreshToken, user.id);
    const accessToken = jsonwebtoken_1.default.sign({ userId: user.id, email: user.email, role: user.role }, env_1.env.JWT_SECRET, { expiresIn: '15m' });
    res.status(200).json({
        success: true,
        data: {
            accessToken,
            refreshToken: newRefreshToken
        }
    });
});
// POST /auth/logout
exports.authRouter.post('/auth/logout', (req, res) => {
    const { refreshToken } = req.body;
    if (refreshToken) {
        store.refreshTokens.delete(refreshToken);
    }
    res.status(200).json({ success: true, message: 'Logged out successfully' });
});
// GET /users/me
exports.authRouter.get('/users/me', auth_middleware_1.authenticateToken, (req, res) => {
    const user = store.users.find((u) => u.id === req.user.userId);
    if (!user) {
        res.status(404).json({ success: false, error: { code: 'NOT_FOUND', message: 'User not found' } });
        return;
    }
    res.status(200).json({
        success: true,
        data: {
            id: user.id,
            email: user.email,
            fullName: user.fullName,
            phoneNumber: user.phoneNumber,
            role: user.role,
            customerSince: user.customerSince,
            primaryAddress: {
                street: '742 Evergreen Terrace',
                apartment: 'Suite 4B',
                city: 'San Francisco',
                state: 'CA',
                postalCode: '94107',
                country: 'US'
            }
        }
    });
});
// PATCH /users/me
exports.authRouter.patch('/users/me', auth_middleware_1.authenticateToken, (req, res) => {
    const user = store.users.find((u) => u.id === req.user.userId);
    if (!user) {
        res.status(404).json({ success: false, error: { code: 'NOT_FOUND', message: 'User not found' } });
        return;
    }
    const { fullName, phoneNumber } = req.body;
    if (fullName)
        user.fullName = fullName;
    if (phoneNumber)
        user.phoneNumber = phoneNumber;
    res.status(200).json({
        success: true,
        data: {
            id: user.id,
            email: user.email,
            fullName: user.fullName,
            phoneNumber: user.phoneNumber,
            role: user.role
        }
    });
});
