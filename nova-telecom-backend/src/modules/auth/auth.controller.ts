import { Router, Request, Response } from 'express';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import crypto from 'crypto';
const uuidv4 = () => crypto.randomUUID();
import { z } from 'zod';
import { env } from '../../config/env';
import { StoreService } from '../../services/store.service';
import { authenticateToken } from '../../middleware/auth.middleware';

export const authRouter = Router();
const store = StoreService.getInstance();

const registerSchema = z.object({
  email: z.string().email(),
  password: z.string().min(6),
  fullName: z.string().min(2),
  phoneNumber: z.string().min(7)
});

const loginSchema = z.object({
  email: z.string().email(),
  password: z.string().min(1)
});

// POST /auth/register
authRouter.post('/auth/register', async (req: Request, res: Response) => {
  const data = registerSchema.parse(req.body);
  const existing = store.users.find((u) => u.email.toLowerCase() === data.email.toLowerCase());

  if (existing) {
    res.status(409).json({
      success: false,
      error: { code: 'EMAIL_ALREADY_REGISTERED', message: 'An account with this email address already exists.' }
    });
    return;
  }

  const passwordHash = await bcrypt.hash(data.password, 10);
  const newUser = {
    id: `usr_${uuidv4().substring(0, 8)}`,
    email: data.email.toLowerCase(),
    passwordHash,
    fullName: data.fullName,
    phoneNumber: data.phoneNumber,
    role: 'CUSTOMER' as const,
    customerSince: new Date().toISOString()
  };
  store.users.push(newUser);

  const accessToken = jwt.sign(
    { userId: newUser.id, email: newUser.email, role: newUser.role },
    env.JWT_SECRET,
    { expiresIn: '15m' }
  );
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
authRouter.post('/auth/login', async (req: Request, res: Response) => {
  const data = loginSchema.parse(req.body);
  const user = store.users.find((u) => u.email.toLowerCase() === data.email.toLowerCase());

  if (!user || !(await bcrypt.compare(data.password, user.passwordHash))) {
    res.status(401).json({
      success: false,
      error: { code: 'INVALID_CREDENTIALS', message: 'Invalid email or password.' }
    });
    return;
  }

  const accessToken = jwt.sign(
    { userId: user.id, email: user.email, role: user.role },
    env.JWT_SECRET,
    { expiresIn: '15m' }
  );
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
authRouter.post('/auth/refresh', (req: Request, res: Response) => {
  const { refreshToken } = req.body;
  if (!refreshToken || !store.refreshTokens.has(refreshToken)) {
    res.status(401).json({
      success: false,
      error: { code: 'INVALID_REFRESH_TOKEN', message: 'Refresh token is expired, revoked, or invalid' }
    });
    return;
  }

  const userId = store.refreshTokens.get(refreshToken)!;
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

  const accessToken = jwt.sign(
    { userId: user.id, email: user.email, role: user.role },
    env.JWT_SECRET,
    { expiresIn: '15m' }
  );

  res.status(200).json({
    success: true,
    data: {
      accessToken,
      refreshToken: newRefreshToken
    }
  });
});

// POST /auth/logout
authRouter.post('/auth/logout', (req: Request, res: Response) => {
  const { refreshToken } = req.body;
  if (refreshToken) {
    store.refreshTokens.delete(refreshToken);
  }
  res.status(200).json({ success: true, message: 'Logged out successfully' });
});

// GET /users/me
authRouter.get('/users/me', authenticateToken, (req: Request, res: Response) => {
  const user = store.users.find((u) => u.id === req.user!.userId);
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
authRouter.patch('/users/me', authenticateToken, (req: Request, res: Response) => {
  const user = store.users.find((u) => u.id === req.user!.userId);
  if (!user) {
    res.status(404).json({ success: false, error: { code: 'NOT_FOUND', message: 'User not found' } });
    return;
  }

  const { fullName, phoneNumber } = req.body;
  if (fullName) user.fullName = fullName;
  if (phoneNumber) user.phoneNumber = phoneNumber;

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
