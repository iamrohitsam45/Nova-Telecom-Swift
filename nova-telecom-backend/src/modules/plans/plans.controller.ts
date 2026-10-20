import { Router, Request, Response } from 'express';
import { StoreService } from '../../services/store.service';

export const plansRouter = Router();
const store = StoreService.getInstance();

// GET /plans
plansRouter.get('/plans', (req: Request, res: Response) => {
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
plansRouter.get('/plans/compare', (req: Request, res: Response) => {
  const idsParam = req.query.ids as string;
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
plansRouter.get('/plans/:id', (req: Request, res: Response) => {
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
