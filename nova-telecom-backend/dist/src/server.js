"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const app_1 = require("./app");
const env_1 = require("./config/env");
const app = (0, app_1.createApp)();
const server = app.listen(env_1.env.PORT, () => {
    console.log(`=======================================================`);
    console.log(`🚀 NOVA TELECOM SERVICES BACKEND RUNNING`);
    console.log(`📡 URL: http://localhost:${env_1.env.PORT}`);
    console.log(`📑 OpenAPI / Swagger Docs: http://localhost:${env_1.env.PORT}/api/docs`);
    console.log(`🔒 Environment: ${env_1.env.NODE_ENV}`);
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
