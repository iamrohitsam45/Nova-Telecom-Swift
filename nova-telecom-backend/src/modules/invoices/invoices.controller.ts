import { Router, Request, Response } from 'express';
import crypto from 'crypto';
import { StoreService } from '../../services/store.service';
import { authenticateToken } from '../../middleware/auth.middleware';
import { MockTelecomAdapter } from '../../adapters/telecom.adapter';
import { env } from '../../config/env';

export const invoicesRouter = Router();
const store = StoreService.getInstance();
const paymentsStore = new Map<string, any>();

// GET /invoices
invoicesRouter.get('/invoices', authenticateToken, (req: Request, res: Response) => {
  res.status(200).json({
    success: true,
    total: store.invoices.length,
    data: store.invoices
  });
});

// GET /invoices/:id
invoicesRouter.get('/invoices/:id', authenticateToken, (req: Request, res: Response) => {
  const inv = store.invoices.find((i) => i.id === req.params.id || i.invoiceNumber === req.params.id);
  if (!inv) {
    res.status(404).json({ success: false, error: { code: 'INVOICE_NOT_FOUND', message: 'Invoice not found' } });
    return;
  }

  res.status(200).json({
    success: true,
    data: inv
  });
});

// POST /payments/checkout
invoicesRouter.post('/payments/checkout', authenticateToken, async (req: Request, res: Response) => {
  const { invoiceId, amountMinorUnits, paymentMethod = 'Apple Pay', idempotencyKey } = req.body;

  if (!idempotencyKey) {
    res.status(400).json({ success: false, error: { code: 'MISSING_IDEMPOTENCY_KEY', message: 'idempotencyKey is required' } });
    return;
  }

  if (paymentsStore.has(idempotencyKey)) {
    res.status(200).json(paymentsStore.get(idempotencyKey));
    return;
  }

  const result = await MockTelecomAdapter.processPayment({
    idempotencyKey,
    amountMinorUnits: amountMinorUnits || 10498,
    currency: 'USD',
    paymentMethod,
    customerEmail: req.user!.email
  });

  const inv = store.invoices.find((i) => i.id === invoiceId);
  if (inv) {
    inv.status = 'PAID';
  }

  const payload = {
    success: true,
    data: result
  };

  paymentsStore.set(idempotencyKey, payload);
  res.status(200).json(payload);
});

// GET /payments/:id
invoicesRouter.get('/payments/:id', authenticateToken, (req: Request, res: Response) => {
  const tx = Array.from(paymentsStore.values()).find((p) => p.data?.transactionId === req.params.id);
  if (!tx) {
    res.status(404).json({ success: false, error: { code: 'PAYMENT_NOT_FOUND', message: 'Payment record not found' } });
    return;
  }
  res.status(200).json(tx);
});

// POST /payments/webhooks/:provider
invoicesRouter.post('/payments/webhooks/:provider', (req: Request, res: Response) => {
  const provider = req.params.provider;
  const signature = req.headers['x-telecom-signature'] as string;

  // Webhook signature verification
  const expectedSig = crypto
    .createHmac('sha256', env.WEBHOOK_SECRET)
    .update(JSON.stringify(req.body))
    .digest('hex');

  const isValid = signature && crypto.timingSafeEqual(Buffer.from(signature), Buffer.from(expectedSig));
  if (!isValid && env.NODE_ENV === 'production') {
    res.status(401).json({ success: false, error: { code: 'INVALID_SIGNATURE', message: 'Webhook signature verification failed.' } });
    return;
  }

  res.status(200).json({
    received: true,
    provider,
    status: 'EVENT_ACKNOWLEDGED'
  });
});
