"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.notificationsRouter = void 0;
const express_1 = require("express");
const auth_middleware_1 = require("../../middleware/auth.middleware");
exports.notificationsRouter = (0, express_1.Router)();
const sampleNotifications = [
    {
        id: 'notif_01',
        title: 'Monthly Bill Ready',
        body: 'Your Nova Gigabit Fiber Pro statement of $79.99 is ready for review.',
        category: 'BILLING',
        isRead: false,
        createdAt: new Date(Date.now() - 4 * 3600 * 1000).toISOString()
    },
    {
        id: 'notif_02',
        title: 'Optical Network Firmware Updated',
        body: 'Your Nova WiFi 7 Mesh Gateway was updated to firmware 4.2.1-patch2.',
        category: 'HARDWARE',
        isRead: true,
        createdAt: new Date(Date.now() - 24 * 3600 * 1000).toISOString()
    }
];
// GET /notifications
exports.notificationsRouter.get('/notifications', auth_middleware_1.authenticateToken, (req, res) => {
    res.status(200).json({
        success: true,
        data: sampleNotifications
    });
});
// PATCH /notifications/:id/read
exports.notificationsRouter.patch('/notifications/:id/read', auth_middleware_1.authenticateToken, (req, res) => {
    const notif = sampleNotifications.find((n) => n.id === req.params.id);
    if (notif) {
        notif.isRead = true;
    }
    res.status(200).json({
        success: true,
        data: notif
    });
});
// POST /devices/push-token
exports.notificationsRouter.post('/devices/push-token', auth_middleware_1.authenticateToken, (req, res) => {
    const { apnsToken, platform } = req.body;
    res.status(200).json({
        success: true,
        message: 'APNs push notification token registered successfully.',
        registeredAt: new Date().toISOString()
    });
});
