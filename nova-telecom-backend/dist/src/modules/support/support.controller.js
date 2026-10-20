"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.supportRouter = void 0;
const express_1 = require("express");
const crypto_1 = __importDefault(require("crypto"));
const uuidv4 = () => crypto_1.default.randomUUID();
const store_service_1 = require("../../services/store.service");
const auth_middleware_1 = require("../../middleware/auth.middleware");
exports.supportRouter = (0, express_1.Router)();
const store = store_service_1.StoreService.getInstance();
// GET /support/faqs
exports.supportRouter.get('/support/faqs', (req, res) => {
    const { category, search } = req.query;
    let items = [...store.faqs];
    if (category) {
        items = items.filter((f) => f.category === category);
    }
    if (search) {
        const q = search.toLowerCase();
        items = items.filter((f) => f.question.toLowerCase().includes(q) || f.answer.toLowerCase().includes(q));
    }
    res.status(200).json({
        success: true,
        total: items.length,
        data: items
    });
});
// GET /support/tickets
exports.supportRouter.get('/support/tickets', auth_middleware_1.authenticateToken, (req, res) => {
    res.status(200).json({
        success: true,
        total: store.tickets.length,
        data: store.tickets
    });
});
// POST /support/tickets
exports.supportRouter.post('/support/tickets', auth_middleware_1.authenticateToken, (req, res) => {
    const { title, category, priority = 'MEDIUM', initialMessage, scheduledAppointment } = req.body;
    const newTicket = {
        id: `tck_${uuidv4().substring(0, 8)}`,
        ticketNumber: `TCK-${Math.floor(1000 + Math.random() * 9000)}-01`,
        userId: req.user.userId,
        title,
        category: category || 'General Inquiry',
        priority,
        status: 'OPEN',
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString(),
        scheduledAppointment: scheduledAppointment || null,
        messages: [
            {
                id: `msg_${uuidv4().substring(0, 8)}`,
                sender: req.user.email,
                isFromUser: true,
                message: initialMessage || 'I need assistance with my telecom hardware/service.',
                timestamp: new Date().toISOString()
            },
            {
                id: `msg_${uuidv4().substring(0, 8)}`,
                sender: 'Nova Assistant',
                isFromUser: false,
                message: 'Your support ticket has been registered. Diagnostics for your line have been initiated.',
                timestamp: new Date().toISOString()
            }
        ]
    };
    store.tickets.unshift(newTicket);
    res.status(201).json({
        success: true,
        data: newTicket
    });
});
// GET /support/tickets/:id
exports.supportRouter.get('/support/tickets/:id', auth_middleware_1.authenticateToken, (req, res) => {
    const ticket = store.tickets.find((t) => t.id === req.params.id || t.ticketNumber === req.params.id);
    if (!ticket) {
        res.status(404).json({ success: false, error: { code: 'TICKET_NOT_FOUND', message: 'Support ticket not found' } });
        return;
    }
    res.status(200).json({
        success: true,
        data: ticket
    });
});
// POST /support/tickets/:id/messages
exports.supportRouter.post('/support/tickets/:id/messages', auth_middleware_1.authenticateToken, (req, res) => {
    const { message, attachmentUrl } = req.body;
    const ticket = store.tickets.find((t) => t.id === req.params.id || t.ticketNumber === req.params.id);
    if (!ticket) {
        res.status(404).json({ success: false, error: { code: 'TICKET_NOT_FOUND', message: 'Support ticket not found' } });
        return;
    }
    const userMsg = {
        id: `msg_${uuidv4().substring(0, 8)}`,
        sender: req.user.email,
        isFromUser: true,
        message,
        attachmentUrl,
        timestamp: new Date().toISOString()
    };
    ticket.messages.push(userMsg);
    ticket.updatedAt = new Date().toISOString();
    // Simulated agent auto-reply
    setTimeout(() => {
        ticket.messages.push({
            id: `msg_${uuidv4().substring(0, 8)}`,
            sender: 'Nova Engineering Support',
            isFromUser: false,
            message: 'Acknowledged. We are cross-referencing your device logs and trace telemetry.',
            timestamp: new Date().toISOString()
        });
    }, 1000);
    res.status(201).json({
        success: true,
        data: userMsg
    });
});
