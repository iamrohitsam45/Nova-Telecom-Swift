"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.plansRouter = void 0;
const express_1 = require("express");
const store_service_1 = require("../../services/store.service");
exports.plansRouter = (0, express_1.Router)();
const store = store_service_1.StoreService.getInstance();
// GET /plans
exports.plansRouter.get('/plans', (req, res) => {
    const { type, popular } = req.query;
    let items = [...store.plans];
    if (type) {
        items = items.filter((p) => p.type === type);
    }
    if (popular === 'true') {
        items = items.filter((p) => p.isPopular);
    }
    res.status(200).json({
        success: true,
        total: items.length,
        data: items
    });
});
// GET /plans/compare
exports.plansRouter.get('/plans/compare', (req, res) => {
    const idsParam = req.query.ids;
    if (!idsParam) {
        res.status(400).json({ success: false, error: { code: 'MISSING_IDS', message: 'Query parameter ids is required' } });
        return;
    }
    const ids = idsParam.split(',');
    const matched = store.plans.filter((p) => ids.includes(p.id));
    res.status(200).json({
        success: true,
        data: matched
    });
});
// GET /plans/:id
exports.plansRouter.get('/plans/:id', (req, res) => {
    const plan = store.plans.find((p) => p.id === req.params.id);
    if (!plan) {
        res.status(404).json({ success: false, error: { code: 'PLAN_NOT_FOUND', message: 'Plan does not exist' } });
        return;
    }
    res.status(200).json({
        success: true,
        data: plan
    });
});
