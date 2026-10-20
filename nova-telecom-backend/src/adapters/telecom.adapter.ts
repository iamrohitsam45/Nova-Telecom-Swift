/**
 * NOVA TELECOM SERVICES - EXTERNAL INTEGRATION ADAPTERS
 * 
 * Production-ready abstraction boundary for operator APIs, payment gateways,
 * SMS/Email transactional messaging, and optical provisioning systems.
 * When genuine provider credentials are unavailable, MockTelecomAdapter is used
 * with explicit simulation headers and deterministic behavior.
 */

export interface SIMActivationRequest {
  iccid: string;
  puk?: string;
  subscriberName: string;
  addressId: string;
  isEsim: boolean;
}

export interface SIMActivationResult {
  isSimulated: boolean;
  phoneNumber: string;
  iccid: string;
  activationStatus: 'ACTIVATED' | 'PENDING_PORT' | 'REJECTED';
  imsi: string;
  timestamp: string;
}

export interface BroadbandProvisioningRequest {
  serviceId: string;
  installationAddress: string;
  planId: string;
  downloadSpeedMbps: number;
  uploadSpeedMbps: number;
}

export interface SpeedUpgradeResult {
  isSimulated: boolean;
  serviceId: string;
  previousSpeedMbps: number;
  newSpeedMbps: number;
  status: 'PROVISIONED_SUCCESSFULLY' | 'PENDING_DISPATCH';
  effectiveAt: string;
  oltPortTrace: string;
}

export interface PaymentChargeRequest {
  idempotencyKey: string;
  amountMinorUnits: number;
  currency: string;
  paymentMethod: string;
  customerEmail: string;
  metadata?: Record<string, string>;
}

export interface PaymentChargeResult {
  isSimulated: boolean;
  transactionId: string;
  status: 'SUCCESS' | 'DECLINED' | 'REQUIRES_ACTION';
  amountMinorUnits: number;
  currency: string;
  receiptUrl: string;
  settlementTimestamp: string;
}

export class MockTelecomAdapter {
  public static async activateSIM(req: SIMActivationRequest): Promise<SIMActivationResult> {
    return {
      isSimulated: true,
      phoneNumber: `+1 (555) ${Math.floor(100 + Math.random() * 900)}-${Math.floor(1000 + Math.random() * 9000)}`,
      iccid: req.iccid,
      activationStatus: 'ACTIVATED',
      imsi: `310410${Math.floor(100000000 + Math.random() * 900000000)}`,
      timestamp: new Date().toISOString()
    };
  }

  public static async provisionSpeedUpgrade(req: BroadbandProvisioningRequest): Promise<SpeedUpgradeResult> {
    return {
      isSimulated: true,
      serviceId: req.serviceId,
      previousSpeedMbps: 300,
      newSpeedMbps: req.downloadSpeedMbps,
      status: 'PROVISIONED_SUCCESSFULLY',
      effectiveAt: new Date().toISOString(),
      oltPortTrace: `NOVA-OLT-BAY-04/PON-SLOT-02/PORT-12/ONU-88`
    };
  }

  public static async processPayment(req: PaymentChargeRequest): Promise<PaymentChargeResult> {
    return {
      isSimulated: true,
      transactionId: `tx_sim_${Date.now()}_${Math.random().toString(36).substring(2, 9)}`,
      status: 'SUCCESS',
      amountMinorUnits: req.amountMinorUnits,
      currency: req.currency,
      receiptUrl: `https://billing.novatelecom.net/receipts/sim_${req.idempotencyKey}.pdf`,
      settlementTimestamp: new Date().toISOString()
    };
  }

  public static async sendTransactionalAlert(to: string, message: string): Promise<{ isSimulated: boolean; messageId: string }> {
    return {
      isSimulated: true,
      messageId: `msg_${Date.now()}_${Math.random().toString(36).substring(2, 8)}`
    };
  }
}
