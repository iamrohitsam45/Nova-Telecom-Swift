import { Router, Request, Response } from 'express';
import crypto from 'crypto';
const uuidv4 = () => crypto.randomUUID();
import { StoreService } from '../../services/store.service';
import { authenticateToken } from '../../middleware/auth.middleware';

export const cartRouter = Router();
const store = StoreService.getInstance();

const getOrCreateUserCart = (userId: string) => {
  if (!store.cartItems.has(userId)) {
    store.cartItems.set(userId, []);
  }
  return store.cartItems.get(userId)!;
};

// GET /cart
cartRouter.get('/cart', authenticateToken, (req: Request, res: Response) => {
  const userId = req.user!.userId;
  const rawItems = getOrCreateUserCart(userId);

  const populatedItems = rawItems
    .map((item) => {
      const product = store.products.find((p) => p.id === item.productId);
      if (!product) return null;
      const subtotalMinorUnits = (product.discountMinorUnits ? product.priceMinorUnits - product.discountMinorUnits : product.priceMinorUnits) * item.quantity;
      return {
        id: item.id,
        product,
        quantity: item.quantity,
        selectedColor: item.selectedColor || 'Cyber Black',
        subtotalMinorUnits
      };
    })
    .filter(Boolean);

  const itemsSubtotalMinorUnits = populatedItems.reduce((acc, item: any) => acc + item.subtotalMinorUnits, 0);
  const estimatedTaxMinorUnits = Math.round(itemsSubtotalMinorUnits * 0.08);
  const shippingMinorUnits = itemsSubtotalMinorUnits > 10000 || populatedItems.length === 0 ? 0 : 999;
  const grandTotalMinorUnits = itemsSubtotalMinorUnits + estimatedTaxMinorUnits + shippingMinorUnits;

  res.status(200).json({
    success: true,
    data: {
      items: populatedItems,
      itemsSubtotalMinorUnits,
      estimatedTaxMinorUnits,
      shippingMinorUnits,
      grandTotalMinorUnits,
      currency: 'USD'
    }
  });
});

// POST /cart/items
cartRouter.post('/cart/items', authenticateToken, (req: Request, res: Response) => {
  const userId = req.user!.userId;
  const { productId, quantity = 1, selectedColor } = req.body;

  const product = store.products.find((p) => p.id === productId);
  if (!product) {
    res.status(404).json({ success: false, error: { code: 'PRODUCT_NOT_FOUND', message: 'Product does not exist' } });
    return;
  }

  const items = getOrCreateUserCart(userId);
  const existing = items.find((i) => i.productId === productId);

  if (existing) {
    existing.quantity += quantity;
  } else {
    items.push({
      id: `ci_${uuidv4().substring(0, 8)}`,
      productId,
      quantity,
      selectedColor: selectedColor || 'Cyber Black'
    });
  }

  res.status(201).json({
    success: true,
    message: 'Item added to cart',
    totalItems: items.reduce((acc, i) => acc + i.quantity, 0)
  });
});

// PATCH /cart/items/:id
cartRouter.patch('/cart/items/:id', authenticateToken, (req: Request, res: Response) => {
  const userId = req.user!.userId;
  const { quantity } = req.body;
  const items = getOrCreateUserCart(userId);
  const item = items.find((i) => i.id === req.params.id);

  if (!item) {
    res.status(404).json({ success: false, error: { code: 'ITEM_NOT_FOUND', message: 'Cart item not found' } });
    return;
  }

  if (quantity <= 0) {
    store.cartItems.set(userId, items.filter((i) => i.id !== req.params.id));
  } else {
    item.quantity = quantity;
  }

  res.status(200).json({ success: true, message: 'Cart updated' });
});

// DELETE /cart/items/:id
cartRouter.delete('/cart/items/:id', authenticateToken, (req: Request, res: Response) => {
  const userId = req.user!.userId;
  const items = getOrCreateUserCart(userId);
  store.cartItems.set(userId, items.filter((i) => i.id !== req.params.id));
  res.status(200).json({ success: true, message: 'Item removed from cart' });
});
