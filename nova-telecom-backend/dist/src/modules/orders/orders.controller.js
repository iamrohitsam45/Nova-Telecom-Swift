"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ordersRouter = void 0;
const express_1 = require("express");
const crypto_1 = __importDefault(require("crypto"));
const uuidv4 = () => crypto_1.default.randomUUID();
const store_service_1 = require("../../services/store.service");
const auth_middleware_1 = require("../../middleware/auth.middleware");
const telecom_adapter_1 = require("../../adapters/telecom.adapter");
exports.ordersRouter = (0, express_1.Router)();
const store = store_service_1.StoreService.getInstance();
// POST /orders
exports.ordersRouter.post('/orders', auth_middleware_1.authenticateToken, async (req, res) => {
    const userId = req.user.userId;
    const { shippingAddress, paymentMethod = 'Apple Pay', idempotencyKey = uuidv4() } = req.body;
    const cartItems = store.cartItems.get(userId) || [];
    if (cartItems.length === 0) {
        res.status(400).json({ success: false, error: { code: 'CART_EMPTY', message: 'Cannot checkout with an empty shopping cart.' } });
        return;
    }
    const items = cartItems.map((ci) => {
        const prod = store.products.find((p) => p.id === ci.productId);
        const unitPrice = prod?.discountMinorUnits ? prod.priceMinorUnits - prod.discountMinorUnits : (prod?.priceMinorUnits || 0);
        return {
            productId: ci.productId,
            productName: prod?.name || 'Telecom Hardware',
            quantity: ci.quantity,
            unitPriceMinorUnits: unitPrice
        };
    });
    const subtotal = items.reduce((acc, i) => acc + i.unitPriceMinorUnits * i.quantity, 0);
    const tax = Math.round(subtotal * 0.08);
    const shipping = subtotal > 10000 ? 0 : 999;
    const grandTotal = subtotal + tax + shipping;
    const paymentResult = await telecom_adapter_1.MockTelecomAdapter.processPayment({
        idempotencyKey,
        amountMinorUnits: grandTotal,
        currency: 'USD',
        paymentMethod,
        customerEmail: req.user.email
    });
    const newOrder = {
        id: `ord_${uuidv4().substring(0, 8)}`,
        orderNumber: `ORD-${Math.floor(1000 + Math.random() * 9000)}-${Math.floor(100 + Math.random() * 900)}`,
        userId,
        createdAt: new Date().toISOString(),
        status: 'PROCESSING',
        items,
        totalAmountMinorUnits: grandTotal,
        currency: 'USD',
        shippingAddress: shippingAddress || {
            street: '742 Evergreen Terrace',
            city: 'San Francisco',
            state: 'CA',
            postalCode: '94107'
        },
        trackingNumber: `NOVA-TRK-${uuidv4().substring(0, 8).toUpperCase()}US`,
        estimatedDeliveryDate: new Date(Date.now() + 2 * 24 * 3600 * 1000).toISOString(),
        payment: {
            transactionId: paymentResult.transactionId,
            status: paymentResult.status,
            receiptUrl: paymentResult.receiptUrl
        }
    };
    store.orders.unshift(newOrder);
    // Clear cart
    store.cartItems.set(userId, []);
    res.status(201).json({
        success: true,
        data: newOrder
    });
});
// GET /orders
exports.ordersRouter.get('/orders', auth_middleware_1.authenticateToken, (req, res) => {
    res.status(200).json({
        success: true,
        total: store.orders.length,
        data: store.orders
    });
});
// GET /orders/:id
exports.ordersRouter.get('/orders/:id', auth_middleware_1.authenticateToken, (req, res) => {
    const order = store.orders.find((o) => o.id === req.params.id || o.orderNumber === req.params.id);
    if (!order) {
        res.status(404).json({ success: false, error: { code: 'ORDER_NOT_FOUND', message: 'Order not found' } });
        return;
    }
    res.status(200).json({
        success: true,
        data: order
    });
});
// POST /orders/:id/cancel
exports.ordersRouter.post('/orders/:id/cancel', auth_middleware_1.authenticateToken, (req, res) => {
    const order = store.orders.find((o) => o.id === req.params.id || o.orderNumber === req.params.id);
    if (!order) {
        res.status(404).json({ success: false, error: { code: 'ORDER_NOT_FOUND', message: 'Order not found' } });
        return;
    }
    if (order.status === 'DELIVERED') {
        res.status(400).json({ success: false, error: { code: 'CANNOT_CANCEL', message: 'Delivered orders must be processed as a return.' } });
        return;
    }
    order.status = 'CANCELLED';
    res.status(200).json({
        success: true,
        message: 'Order cancelled and refund queued.',
        data: order
    });
});
