"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.productsRouter = void 0;
const express_1 = require("express");
const store_service_1 = require("../../services/store.service");
exports.productsRouter = (0, express_1.Router)();
const store = store_service_1.StoreService.getInstance();
// GET /products
exports.productsRouter.get('/products', (req, res) => {
    const { category, search, featured, sort } = req.query;
    let items = [...store.products];
    if (category) {
        items = items.filter((p) => p.category === category);
    }
    if (search) {
        const q = search.toLowerCase();
        items = items.filter((p) => p.name.toLowerCase().includes(q) || p.description.toLowerCase().includes(q));
    }
    if (featured === 'true') {
        items = items.filter((p) => p.isFeatured);
    }
    if (sort === 'price_asc') {
        items.sort((a, b) => a.priceMinorUnits - b.priceMinorUnits);
    }
    else if (sort === 'price_desc') {
        items.sort((a, b) => b.priceMinorUnits - a.priceMinorUnits);
    }
    else if (sort === 'rating') {
        items.sort((a, b) => b.rating - a.rating);
    }
    res.status(200).json({
        success: true,
        total: items.length,
        data: items
    });
});
// GET /products/compare
exports.productsRouter.get('/products/compare', (req, res) => {
    const idsParam = req.query.ids;
    if (!idsParam) {
        res.status(400).json({ success: false, error: { code: 'MISSING_IDS', message: 'Query parameter ids is required' } });
        return;
    }
    const ids = idsParam.split(',');
    const matched = store.products.filter((p) => ids.includes(p.id));
    res.status(200).json({
        success: true,
        data: matched
    });
});
// GET /products/:id
exports.productsRouter.get('/products/:id', (req, res) => {
    const product = store.products.find((p) => p.id === req.params.id);
    if (!product) {
        res.status(404).json({ success: false, error: { code: 'PRODUCT_NOT_FOUND', message: 'Product does not exist' } });
        return;
    }
    res.status(200).json({
        success: true,
        data: product
    });
});
// GET /products/:id/specifications
exports.productsRouter.get('/products/:id/specifications', (req, res) => {
    const product = store.products.find((p) => p.id === req.params.id);
    if (!product) {
        res.status(404).json({ success: false, error: { code: 'PRODUCT_NOT_FOUND', message: 'Product does not exist' } });
        return;
    }
    res.status(200).json({
        success: true,
        data: product.specifications
    });
});
// GET /products/:id/reviews
exports.productsRouter.get('/products/:id/reviews', (req, res) => {
    const product = store.products.find((p) => p.id === req.params.id);
    if (!product) {
        res.status(404).json({ success: false, error: { code: 'PRODUCT_NOT_FOUND', message: 'Product does not exist' } });
        return;
    }
    res.status(200).json({
        success: true,
        data: product.reviews
    });
});
// GET /inventory/:productId
exports.productsRouter.get('/inventory/:productId', (req, res) => {
    const product = store.products.find((p) => p.id === req.params.productId);
    if (!product) {
        res.status(404).json({ success: false, error: { code: 'PRODUCT_NOT_FOUND', message: 'Product not found' } });
        return;
    }
    res.status(200).json({
        success: true,
        data: {
            productId: product.id,
            inStock: product.inStock,
            stockCount: product.stockCount,
            warehouse: 'CENTRAL-WH-01'
        }
    });
});
