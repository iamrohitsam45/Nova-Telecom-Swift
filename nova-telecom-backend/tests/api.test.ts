import request from 'supertest';
import { createApp } from '../src/app';

const app = createApp();

describe('Nova Telecom Core API Integration Tests', () => {
  let authToken: string;
  let refreshToken: string;

  it('1. Health check returns 200 and healthy status', async () => {
    const res = await request(app).get('/health');
    expect(res.status).toBe(200);
    expect(res.body.status).toBe('HEALTHY');
    expect(res.body.service).toContain('Nova Telecom');
  });

  it('2. POST /auth/login with valid demo credentials', async () => {
    const res = await request(app).post('/api/v1/auth/login').send({
      email: 'alex.mercer@novatelecom.io',
      password: 'Password123!'
    });

    expect(res.status).toBe(200);
    expect(res.body.success).toBe(true);
    expect(res.body.data.accessToken).toBeDefined();
    expect(res.body.data.refreshToken).toBeDefined();
    expect(res.body.data.user.email).toBe('alex.mercer@novatelecom.io');

    authToken = res.body.data.accessToken;
    refreshToken = res.body.data.refreshToken;
  });

  it('3. POST /auth/login with invalid password returns 401', async () => {
    const res = await request(app).post('/api/v1/auth/login').send({
      email: 'alex.mercer@novatelecom.io',
      password: 'WrongPassword'
    });

    expect(res.status).toBe(401);
    expect(res.body.success).toBe(false);
  });

  it('4. POST /auth/refresh rotates token successfully', async () => {
    const res = await request(app).post('/api/v1/auth/refresh').send({
      refreshToken
    });

    expect(res.status).toBe(200);
    expect(res.body.success).toBe(true);
    expect(res.body.data.accessToken).toBeDefined();
    expect(res.body.data.refreshToken).toBeDefined();

    // Use refreshed token for subsequent tests
    authToken = res.body.data.accessToken;
  });

  it('5. GET /users/me with Bearer token returns profile', async () => {
    const res = await request(app)
      .get('/api/v1/users/me')
      .set('Authorization', `Bearer ${authToken}`);

    expect(res.status).toBe(200);
    expect(res.body.data.fullName).toBe('Alex Mercer');
    expect(res.body.data.primaryAddress.city).toBe('San Francisco');
  });

  it('6. GET /products returns catalog with 3D model asset names', async () => {
    const res = await request(app).get('/api/v1/products');
    expect(res.status).toBe(200);
    expect(res.body.data.length).toBeGreaterThanOrEqual(12);

    const router = res.body.data.find((p: any) => p.id === 'prod_router_pro7');
    expect(router).toBeDefined();
    expect(router.model3DAsset).toBe('NovaRouterPro3D');
    expect(router.ports).toContain('1x 10G SFP+ Fiber');
  });

  it('7. GET /products filter by category WIFI_ROUTERS', async () => {
    const res = await request(app).get('/api/v1/products?category=WIFI_ROUTERS');
    expect(res.status).toBe(200);
    for (const p of res.body.data) {
      expect(p.category).toBe('WIFI_ROUTERS');
    }
  });

  it('8. GET /products/compare returns compared items', async () => {
    const res = await request(app).get('/api/v1/products/compare?ids=prod_router_pro7,prod_mesh_orbit3');
    expect(res.status).toBe(200);
    expect(res.body.data.length).toBe(2);
  });

  it('9. GET /plans returns mobile, fiber, and DTH plans', async () => {
    const res = await request(app).get('/api/v1/plans');
    expect(res.status).toBe(200);
    expect(res.body.data.length).toBeGreaterThanOrEqual(12);

    const fiberPlan = res.body.data.find((p: any) => p.id === 'plan_fiber_1000');
    expect(fiberPlan).toBeDefined();
    expect(fiberPlan.downloadSpeedMbps).toBe(1000);
  });

  it('10. POST /broadband/availability checks fiber serviceability', async () => {
    const res = await request(app).post('/api/v1/broadband/availability').send({
      postalCode: '94107',
      address: '742 Evergreen Terrace'
    });

    expect(res.status).toBe(200);
    expect(res.body.data.isFiberAvailable).toBe(true);
    expect(res.body.data.maxDownloadSpeedMbps).toBe(10000);
  });

  it('11. POST /broadband/speed-upgrades provisions speed tier', async () => {
    const res = await request(app)
      .post('/api/v1/broadband/speed-upgrades')
      .set('Authorization', `Bearer ${authToken}`)
      .send({
        targetDownloadSpeedMbps: 2500,
        targetUploadSpeedMbps: 2500,
        planName: 'Nova Fiber Extreme 2.5 Gbps'
      });

    expect(res.status).toBe(200);
    expect(res.body.data.status).toBe('PROVISIONED_SUCCESSFULLY');
    expect(res.body.data.isSimulated).toBe(true);
  });

  it('12. Cart and Order Checkout flow', async () => {
    // Add router to cart
    const addRes = await request(app)
      .post('/api/v1/cart/items')
      .set('Authorization', `Bearer ${authToken}`)
      .send({ productId: 'prod_router_pro7', quantity: 1 });
    expect(addRes.status).toBe(201);

    // Get cart
    const cartRes = await request(app)
      .get('/api/v1/cart')
      .set('Authorization', `Bearer ${authToken}`);
    expect(cartRes.status).toBe(200);
    expect(cartRes.body.data.items.length).toBeGreaterThan(0);

    // Checkout order
    const orderRes = await request(app)
      .post('/api/v1/orders')
      .set('Authorization', `Bearer ${authToken}`)
      .send({ paymentMethod: 'Apple Pay' });
    expect(orderRes.status).toBe(201);
    expect(orderRes.body.data.orderNumber).toBeDefined();
    expect(orderRes.body.data.trackingNumber).toBeDefined();
  });

  it('13. POST /recharges with idempotency prevents duplicate charges', async () => {
    const key = `test_idemp_${Date.now()}`;
    const payload = {
      simCardId: 'sim_primary_8821',
      amountMinorUnits: 2999,
      idempotencyKey: key
    };

    const first = await request(app)
      .post('/api/v1/recharges')
      .set('Authorization', `Bearer ${authToken}`)
      .send(payload);

    expect(first.status).toBe(201);
    expect(first.body.data.rechargeId).toBeDefined();

    // Replay exact same request with same idempotency key
    const second = await request(app)
      .post('/api/v1/recharges')
      .set('Authorization', `Bearer ${authToken}`)
      .send(payload);

    expect(second.status).toBe(200);
    expect(second.body.data.rechargeId).toBe(first.body.data.rechargeId);
  });

  it('14. GET /invoices returns billing statements', async () => {
    const res = await request(app)
      .get('/api/v1/invoices')
      .set('Authorization', `Bearer ${authToken}`);

    expect(res.status).toBe(200);
    expect(res.body.data.length).toBeGreaterThan(0);
    expect(res.body.data[0].invoiceNumber).toBeDefined();
  });

  it('15. POST /support/tickets creates ticket with diagnostics', async () => {
    const res = await request(app)
      .post('/api/v1/support/tickets')
      .set('Authorization', `Bearer ${authToken}`)
      .send({
        title: 'Router WPS Sync Assistance',
        category: 'Hardware',
        priority: 'MEDIUM',
        initialMessage: 'Troubleshooting WPS button pairing with satellite mesh node.'
      });

    expect(res.status).toBe(201);
    expect(res.body.data.ticketNumber).toBeDefined();
    expect(res.body.data.messages.length).toBe(2);
  });

  it('16. GET /support/faqs returns knowledge base articles', async () => {
    const res = await request(app).get('/api/v1/support/faqs');
    expect(res.status).toBe(200);
    expect(res.body.data.length).toBeGreaterThan(0);
  });
});
