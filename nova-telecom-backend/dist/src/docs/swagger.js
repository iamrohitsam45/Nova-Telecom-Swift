"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.openApiSpec = void 0;
exports.openApiSpec = {
    openapi: '3.0.3',
    info: {
        title: 'Nova Telecom Services API',
        version: '1.0.0',
        description: 'High-speed fiber broadband, 5G mobile recharge, DTH television, streaming subscriptions, 3D hardware catalog, billing, and support service APIs.',
        contact: {
            name: 'Nova Telecom Developer Platform',
            url: 'https://developer.novatelecom.net',
            email: 'api-support@novatelecom.net'
        }
    },
    servers: [
        { url: 'http://localhost:4000/api/v1', description: 'Local Development Server' },
        { url: 'https://staging-api.novatelecom.net/api/v1', description: 'Staging Environment' }
    ],
    components: {
        securitySchemes: {
            BearerAuth: {
                type: 'http',
                scheme: 'bearer',
                bearerFormat: 'JWT'
            }
        }
    },
    paths: {
        '/auth/register': {
            post: {
                summary: 'Register a new customer account',
                tags: ['Authentication'],
                requestBody: {
                    required: true,
                    content: { 'application/json': { schema: { type: 'object', properties: { email: { type: 'string' }, password: { type: 'string' }, fullName: { type: 'string' }, phoneNumber: { type: 'string' } } } } }
                },
                responses: { '201': { description: 'Registered successfully' }, '409': { description: 'Email already exists' } }
            }
        },
        '/auth/login': {
            post: {
                summary: 'Sign in to account with email and password',
                tags: ['Authentication'],
                requestBody: {
                    required: true,
                    content: { 'application/json': { schema: { type: 'object', properties: { email: { type: 'string' }, password: { type: 'string' } } } } }
                },
                responses: { '200': { description: 'Authenticated successfully with tokens' }, '401': { description: 'Invalid credentials' } }
            }
        },
        '/auth/refresh': {
            post: {
                summary: 'Rotate and exchange refresh token for new access token',
                tags: ['Authentication'],
                responses: { '200': { description: 'Token refreshed' }, '401': { description: 'Invalid or revoked token' } }
            }
        },
        '/products': {
            get: {
                summary: 'Query telecom product catalog',
                tags: ['Products'],
                parameters: [
                    { name: 'category', in: 'query', schema: { type: 'string' } },
                    { name: 'search', in: 'query', schema: { type: 'string' } },
                    { name: 'featured', in: 'query', schema: { type: 'boolean' } }
                ],
                responses: { '200': { description: 'Product list returned' } }
            }
        },
        '/products/{id}': {
            get: {
                summary: 'Retrieve single product details and 3D asset metadata',
                tags: ['Products'],
                parameters: [{ name: 'id', in: 'path', required: true, schema: { type: 'string' } }],
                responses: { '200': { description: 'Product details' }, '404': { description: 'Product not found' } }
            }
        },
        '/plans': {
            get: {
                summary: 'List telecom plans (Mobile 5G, Fiber Broadband, DTH TV, OTT)',
                tags: ['Plans & Telecom'],
                parameters: [{ name: 'type', in: 'query', schema: { type: 'string' } }],
                responses: { '200': { description: 'Plans list' } }
            }
        },
        '/broadband/availability': {
            post: {
                summary: 'Check fiber broadband availability by postal code and address',
                tags: ['Plans & Telecom'],
                responses: { '200': { description: 'Availability report' } }
            }
        },
        '/broadband/speed-upgrades': {
            post: {
                summary: 'Request optical line speed upgrade',
                security: [{ BearerAuth: [] }],
                tags: ['Plans & Telecom'],
                responses: { '200': { description: 'Speed upgrade provisioned' } }
            }
        },
        '/recharges': {
            post: {
                summary: 'Perform instant mobile SIM recharge with idempotency protection',
                security: [{ BearerAuth: [] }],
                tags: ['Plans & Telecom'],
                responses: { '201': { description: 'Recharge processed' } }
            }
        },
        '/cart': {
            get: {
                summary: 'Retrieve current customer shopping cart',
                security: [{ BearerAuth: [] }],
                tags: ['Shopping & Cart'],
                responses: { '200': { description: 'Cart contents' } }
            }
        },
        '/orders': {
            post: {
                summary: 'Checkout cart and create telecom hardware shipment order',
                security: [{ BearerAuth: [] }],
                tags: ['Shopping & Cart'],
                responses: { '201': { description: 'Order created' } }
            }
        },
        '/invoices': {
            get: {
                summary: 'List billing invoices and downloadable statements',
                security: [{ BearerAuth: [] }],
                tags: ['Billing'],
                responses: { '200': { description: 'Invoice list' } }
            }
        },
        '/support/tickets': {
            get: {
                summary: 'List customer support tickets and line traces',
                security: [{ BearerAuth: [] }],
                tags: ['Support'],
                responses: { '200': { description: 'Tickets list' } }
            },
            post: {
                summary: 'Create a new support ticket with diagnostics',
                security: [{ BearerAuth: [] }],
                tags: ['Support'],
                responses: { '201': { description: 'Ticket created' } }
            }
        }
    }
};
