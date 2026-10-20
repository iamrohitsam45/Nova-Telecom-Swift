"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.invoicesRouter = void 0;
const express_1 = require("express");
const crypto_1 = __importDefault(require("crypto"));
const store_service_1 = require("../../services/store.service");
const auth_middleware_1 = require("../../middleware/auth.middleware");
const telecom_adapter_1 = require("../../adapters/telecom.adapter");
const env_1 = require("../../config/env");
exports.invoicesRouter = (0, express_1.Router)();
const store = store_service_1.StoreService.getInstance();
const paymentsStore = new Map();
// GET /invoices
exports.invoicesRouter.get('/invoices', auth_middleware_1.authenticateToken, (req, res) => {
    res.status(200).json({
        success: true,
        total: store.invoices.length,
        data: store.invoices
    });
});
// GET /invoices/:id
exports.invoicesRouter.get('/invoices/:id', auth_middleware_1.authenticateToken, (req, res) => {
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
exports.invoicesRouter.post('/payments/checkout', auth_middleware_1.authenticateToken, async (req, res) => {
    const { invoiceId, amountMinorUnits, paymentMethod = 'Apple Pay', idempotencyKey } = req.body;
    if (!idempotencyKey) {
        res.status(400).json({ success: false, error: { code: 'MISSING_IDEMPOTENCY_KEY', message: 'idempotencyKey is required' } });
        return;
    }
    if (paymentsStore.has(idempotencyKey)) {
        res.status(200).json(paymentsStore.get(idempotencyKey));
        return;
    }
    const result = await telecom_adapter_1.MockTelecomAdapter.processPayment({
        idempotencyKey,
        amountMinorUnits: amountMinorUnits || 10498,
        currency: 'USD',
        paymentMethod,
        customerEmail: req.user.email
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
exports.invoicesRouter.get('/payments/:id', auth_middleware_1.authenticateToken, (req, res) => {
    const tx = Array.from(paymentsStore.values()).find((p) => p.data?.transactionId === req.params.id);
    if (!tx) {
        res.status(404).json({ success: false, error: { code: 'PAYMENT_NOT_FOUND', message: 'Payment record not found' } });
        return;
    }
    res.status(200).json(tx);
});
// POST /payments/webhooks/:provider
exports.invoicesRouter.post('/payments/webhooks/:provider', (req, res) => {
    const provider = req.params.provider;
    const signature = req.headers['x-telecom-signature'];
    // Webhook signature verification
    const expectedSig = crypto_1.default
        .createHmac('sha256', env_1.env.WEBHOOK_SECRET)
        .update(JSON.stringify(req.body))
        .digest('hex');
    const isValid = signature && crypto_1.default.timingSafeEqual(Buffer.from(signature), Buffer.from(expectedSig));
    if (!isValid && env_1.env.NODE_ENV === 'production') {
        res.status(401).json({ success: false, error: { code: 'INVALID_SIGNATURE', message: 'Webhook signature verification failed.' } });
        return;
    }
    res.status(200).json({
        received: true,
        provider,
        status: 'EVENT_ACKNOWLEDGED'
    });
});
