"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.createApp = void 0;
const express_1 = __importDefault(require("express"));
const cors_1 = __importDefault(require("cors"));
const helmet_1 = __importDefault(require("helmet"));
const morgan_1 = __importDefault(require("morgan"));
const swagger_ui_express_1 = __importDefault(require("swagger-ui-express"));
const swagger_1 = require("./docs/swagger");
const error_middleware_1 = require("./middleware/error.middleware");
const rate_limit_middleware_1 = require("./middleware/rate-limit.middleware");
const auth_controller_1 = require("./modules/auth/auth.controller");
const products_controller_1 = require("./modules/products/products.controller");
const plans_controller_1 = require("./modules/plans/plans.controller");
const accounts_controller_1 = require("./modules/accounts/accounts.controller");
const cart_controller_1 = require("./modules/cart/cart.controller");
const orders_controller_1 = require("./modules/orders/orders.controller");
const invoices_controller_1 = require("./modules/invoices/invoices.controller");
const support_controller_1 = require("./modules/support/support.controller");
const notifications_controller_1 = require("./modules/notifications/notifications.controller");
const createApp = () => {
    const app = (0, express_1.default)();
    // Security & Logging
    app.use((0, helmet_1.default)({ contentSecurityPolicy: false }));
    app.use((0, cors_1.default)({ origin: '*', credentials: true }));
    app.use((0, morgan_1.default)('dev'));
    app.use(express_1.default.json());
    app.use(express_1.default.urlencoded({ extended: true }));
    // Global Rate Limiting: 120 requests / minute
    app.use((0, rate_limit_middleware_1.rateLimiter)({ windowMs: 60 * 1000, maxRequests: 120 }));
    // Health Checks
    const healthHandler = (req, res) => {
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
    app.use('/api/docs', swagger_ui_express_1.default.serve, swagger_ui_express_1.default.setup(swagger_1.openApiSpec));
    app.get('/api/docs.json', (req, res) => {
        res.json(swagger_1.openApiSpec);
    });
    // API v1 Routes
    const apiV1 = express_1.default.Router();
    apiV1.use(auth_controller_1.authRouter);
    apiV1.use(products_controller_1.productsRouter);
    apiV1.use(plans_controller_1.plansRouter);
    apiV1.use(accounts_controller_1.accountsRouter);
    apiV1.use(cart_controller_1.cartRouter);
    apiV1.use(orders_controller_1.ordersRouter);
    apiV1.use(invoices_controller_1.invoicesRouter);
    apiV1.use(support_controller_1.supportRouter);
    apiV1.use(notifications_controller_1.notificationsRouter);
    app.use('/api/v1', apiV1);
    // Global Error Handler
    app.use(error_middleware_1.errorHandler);
    return app;
};
exports.createApp = createApp;
