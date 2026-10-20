import { createApp } from './app';
import { env } from './config/env';

const app = createApp();

const server = app.listen(env.PORT, () => {
  console.log(`=======================================================`);
  console.log(`🚀 NOVA TELECOM SERVICES BACKEND RUNNING`);
  console.log(`📡 URL: http://localhost:${env.PORT}`);
  console.log(`📑 OpenAPI / Swagger Docs: http://localhost:${env.PORT}/api/docs`);
  console.log(`🔒 Environment: ${env.NODE_ENV}`);
  console.log(`=======================================================`);
});

const gracefulShutdown = () => {
  console.log('🛑 Shutting down gracefully...');
  server.close(() => {
    console.log('✅ Closed out remaining connections.');
    process.exit(0);
  });
};

process.on('SIGTERM', gracefulShutdown);
process.on('SIGINT', gracefulShutdown);
