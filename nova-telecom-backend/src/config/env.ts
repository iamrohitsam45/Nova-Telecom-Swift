import dotenv from 'dotenv';
import { z } from 'zod';

dotenv.config();

const envSchema = z.object({
  NODE_ENV: z.enum(['development', 'production', 'test']).default('development'),
  PORT: z.string().transform((val) => parseInt(val, 10)).default(4000 as any),
  DATABASE_URL: z.string().default('postgresql://postgres:postgres@localhost:5432/nova_telecom?schema=public'),
  JWT_SECRET: z.string().default('super-secret-nova-telecom-jwt-access-key-2026'),
  JWT_REFRESH_SECRET: z.string().default('super-secret-nova-telecom-jwt-refresh-key-2026'),
  JWT_EXPIRES_IN: z.string().default('15m'),
  JWT_REFRESH_EXPIRES_IN: z.string().default('7d'),
  REDIS_URL: z.string().default('redis://localhost:6379'),
  ENABLE_DEMO_SEED: z.string().transform((val) => val === 'true').default(true as any),
  WEBHOOK_SECRET: z.string().default('nova_whsec_telecom_test_signature_secret')
});

export const env = envSchema.parse(process.env);
