"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.env = void 0;
const dotenv_1 = __importDefault(require("dotenv"));
const zod_1 = require("zod");
dotenv_1.default.config();
const envSchema = zod_1.z.object({
    NODE_ENV: zod_1.z.enum(['development', 'production', 'test']).default('development'),
    PORT: zod_1.z.string().transform((val) => parseInt(val, 10)).default(4000),
    DATABASE_URL: zod_1.z.string().default('postgresql://postgres:postgres@localhost:5432/nova_telecom?schema=public'),
    JWT_SECRET: zod_1.z.string().default('super-secret-nova-telecom-jwt-access-key-2026'),
    JWT_REFRESH_SECRET: zod_1.z.string().default('super-secret-nova-telecom-jwt-refresh-key-2026'),
    JWT_EXPIRES_IN: zod_1.z.string().default('15m'),
    JWT_REFRESH_EXPIRES_IN: zod_1.z.string().default('7d'),
    REDIS_URL: zod_1.z.string().default('redis://localhost:6379'),
    ENABLE_DEMO_SEED: zod_1.z.string().transform((val) => val === 'true').default(true),
    WEBHOOK_SECRET: zod_1.z.string().default('nova_whsec_telecom_test_signature_secret')
});
exports.env = envSchema.parse(process.env);
