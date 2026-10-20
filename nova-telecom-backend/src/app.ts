import express, { Application, Request, Response } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import swaggerUi from 'swagger-ui-express';
import { openApiSpec } from './docs/swagger';
import { errorHandler } from './middleware/error.middleware';
import { rateLimiter } from './middleware/rate-limit.middleware';
import { authRouter } from './modules/auth/auth.controller';
import { productsRouter } from './modules/products/products.controller';
import { plansRouter } from './modules/plans/plans.controller';
import { accountsRouter } from './modules/accounts/accounts.controller';
import { cartRouter } from './modules/cart/cart.controller';
import { ordersRouter } from './modules/orders/orders.controller';
import { invoicesRouter } from './modules/invoices/invoices.controller';
import { supportRouter } from './modules/support/support.controller';
import { notificationsRouter } from './modules/notifications/notifications.controller';

export const createApp = (): Application => {
  const app = express();

  // Security & Logging
  app.use(helmet({ contentSecurityPolicy: false }));
  app.use(cors({ origin: '*', credentials: true }));
  app.use(morgan('dev'));
  app.use(express.json());
  app.use(express.urlencoded({ extended: true }));

  // Global Rate Limiting: 120 requests / minute
  app.use(rateLimiter({ windowMs: 60 * 1000, maxRequests: 120 }));

  // Health Checks
  const healthHandler = (req: Request, res: Response) => {
    res.status(200).json({
      status: 'HEALTHY',
      service: 'Nova Telecom Core Gateway',
      version: '1.0.0',
      timestamp: new Date().toISOString()
    });
  };
  app.get('/health', healthHandler);
  app.get('/api/v1/health', healthHandler);

  // OpenAPI Swagger Documentation
  app.use('/api/docs', swaggerUi.serve, swaggerUi.setup(openApiSpec));
  app.get('/api/docs.json', (req: Request, res: Response) => {
    res.json(openApiSpec);
  });

  // API v1 Routes
  const apiV1 = express.Router();
  apiV1.use(authRouter);
  apiV1.use(productsRouter);
  apiV1.use(plansRouter);
  apiV1.use(accountsRouter);
  apiV1.use(cartRouter);
  apiV1.use(ordersRouter);
  apiV1.use(invoicesRouter);
  apiV1.use(supportRouter);
  apiV1.use(notificationsRouter);

  app.use('/api/v1', apiV1);

  // Global Error Handler
  app.use(errorHandler);

  return app;
};
