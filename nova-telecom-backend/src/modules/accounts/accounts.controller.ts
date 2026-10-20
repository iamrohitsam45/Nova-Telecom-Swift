import { Router, Request, Response } from 'express';
import crypto from 'crypto';
const uuidv4 = () => crypto.randomUUID();
import { StoreService } from '../../services/store.service';
import { authenticateToken } from '../../middleware/auth.middleware';
import { MockTelecomAdapter } from '../../adapters/telecom.adapter';

export const accountsRouter = Router();
const store = StoreService.getInstance();
const rechargeIdempotencyStore = new Map<string, any>();

// GET /accounts
accountsRouter.get('/accounts', authenticateToken, (req: Request, res: Response) => {
  res.status(200).json({
    success: true,
    data: {
      accountNumber: 'NOVA-ACC-984210',
      status: 'ACTIVE',
      accountHolder: 'Alex Mercer',
      memberSince: '2024-03-15',
      primaryBroadband: store.broadbands[0],
      activeSimCount: store.simCards.length,
      dthSubscribersCount: store.dthAccounts.length
    }
  });
});

// GET /sim-cards
accountsRouter.get('/sim-cards', authenticateToken, (req: Request, res: Response) => {
  res.status(200).json({
    success: true,
    data: store.simCards
  });
});

// POST /recharges
accountsRouter.post('/recharges', authenticateToken, async (req: Request, res: Response) => {
  const { simCardId, amountMinorUnits, planId, idempotencyKey } = req.body;

  if (!idempotencyKey) {
    res.status(400).json({ success: false, error: { code: 'MISSING_IDEMPOTENCY_KEY', message: 'idempotencyKey header or body field is required.' } });
    return;
  }

  // Idempotency Protection
  if (rechargeIdempotencyStore.has(idempotencyKey)) {
    res.status(200).json(rechargeIdempotencyStore.get(idempotencyKey));
    return;
  }

  const sim = store.simCards.find((s) => s.id === simCardId) || store.simCards[0];
  const plan = store.plans.find((p) => p.id === planId);

  const paymentResult = await MockTelecomAdapter.processPayment({
    idempotencyKey,
    amountMinorUnits: amountMinorUnits || (plan ? plan.priceMinorUnits : 2999),
    currency: 'USD',
    paymentMethod: 'Stored Card / Apple Pay',
    customerEmail: req.user!.email
  });

  // Mutate SIM balance
  sim.balanceMinorUnits += amountMinorUnits || 2999;
  sim.dataRemainingGB += 25.0;
  sim.expiryDate = new Date(Date.now() + 30 * 24 * 3600 * 1000).toISOString();

  const responsePayload = {
    success: true,
    data: {
      rechargeId: `rch_${uuidv4().substring(0, 8)}`,
      simPhoneNumber: sim.phoneNumber,
      amountMinorUnits: paymentResult.amountMinorUnits,
      currency: 'USD',
      newBalanceMinorUnits: sim.balanceMinorUnits,
      newDataRemainingGB: sim.dataRemainingGB,
      newExpiryDate: sim.expiryDate,
      isSimulated: paymentResult.isSimulated,
      receiptUrl: paymentResult.receiptUrl,
      timestamp: paymentResult.settlementTimestamp
    }
  };

  rechargeIdempotencyStore.set(idempotencyKey, responsePayload);
  res.status(201).json(responsePayload);
});

// GET /recharges/history
accountsRouter.get('/recharges/history', authenticateToken, (req: Request, res: Response) => {
  res.status(200).json({
    success: true,
    data: [
      {
        id: 'rch_hist_01',
        amountMinorUnits: 2999,
        planName: 'Nova 5G Ultra Max',
        phoneNumber: '+1 (555) 392-8821',
        status: 'SUCCESS',
        date: new Date(Date.now() - 12 * 24 * 3600 * 1000).toISOString(),
        paymentMethod: 'Apple Pay'
      }
    ]
  });
});

// GET /broadband/connections
accountsRouter.get('/broadband/connections', authenticateToken, (req: Request, res: Response) => {
  res.status(200).json({
    success: true,
    data: store.broadbands
  });
});

// POST /broadband/availability
accountsRouter.post('/broadband/availability', (req: Request, res: Response) => {
  const { address, postalCode } = req.body;
  const isAvailable = postalCode ? !postalCode.startsWith('00') : true;

  res.status(200).json({
    success: true,
    data: {
      addressSearched: address || 'Current Location',
      postalCode: postalCode || '94107',
      isFiberAvailable: isAvailable,
      is5GHomeAvailable: true,
      maxDownloadSpeedMbps: isAvailable ? 10000 : 300,
      maxUploadSpeedMbps: isAvailable ? 10000 : 100,
      technologyType: isAvailable ? 'XGS-PON 10Gbps Symmetrical Optical' : '5G Ultra Wideband Fixed Wireless',
      estimatedInstallationDays: 2,
      eligiblePlanIds: ['plan_fiber_300', 'plan_fiber_1000', 'plan_fiber_2500']
    }
  });
});

// POST /broadband/speed-upgrades
accountsRouter.post('/broadband/speed-upgrades', authenticateToken, async (req: Request, res: Response) => {
  const { connectionId, targetDownloadSpeedMbps, targetUploadSpeedMbps, planName } = req.body;

  const result = await MockTelecomAdapter.provisionSpeedUpgrade({
    serviceId: connectionId || 'NOVA-FIBER-9042',
    installationAddress: '742 Evergreen Terrace, San Francisco, CA',
    planId: 'plan_fiber_pro',
    downloadSpeedMbps: targetDownloadSpeedMbps || 1000,
    uploadSpeedMbps: targetUploadSpeedMbps || 1000
  });

  if (store.broadbands.length > 0) {
    store.broadbands[0].downloadSpeedMbps = targetDownloadSpeedMbps || 1000;
    store.broadbands[0].uploadSpeedMbps = targetUploadSpeedMbps || 1000;
    if (planName) store.broadbands[0].planName = planName;
  }

  res.status(200).json({
    success: true,
    data: result
  });
});

// GET /dth/accounts
accountsRouter.get('/dth/accounts', authenticateToken, (req: Request, res: Response) => {
  res.status(200).json({
    success: true,
    data: store.dthAccounts
  });
});

// GET /subscriptions
accountsRouter.get('/subscriptions', authenticateToken, (req: Request, res: Response) => {
  res.status(200).json({
    success: true,
    data: store.subscriptions
  });
});

// POST /subscriptions/:id/activate
accountsRouter.post('/subscriptions/:id/activate', authenticateToken, (req: Request, res: Response) => {
  const sub = store.subscriptions.find((s) => s.id === req.params.id);
  if (sub) {
    sub.isActivated = true;
  }
  res.status(200).json({
    success: true,
    message: 'Subscription successfully activated and billed to your Nova telecom account.',
    data: sub
  });
});

// POST /subscriptions/:id/cancel
accountsRouter.post('/subscriptions/:id/cancel', authenticateToken, (req: Request, res: Response) => {
  const sub = store.subscriptions.find((s) => s.id === req.params.id);
  if (sub) {
    sub.isActivated = false;
  }
  res.status(200).json({
    success: true,
    message: 'Subscription cancelled. Access will remain active until end of billing cycle.',
    data: sub
  });
});
