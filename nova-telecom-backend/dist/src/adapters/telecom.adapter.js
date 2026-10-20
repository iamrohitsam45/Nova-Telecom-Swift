"use strict";
/**
 * NOVA TELECOM SERVICES - EXTERNAL INTEGRATION ADAPTERS
 *
 * Production-ready abstraction boundary for operator APIs, payment gateways,
 * SMS/Email transactional messaging, and optical provisioning systems.
 * When genuine provider credentials are unavailable, MockTelecomAdapter is used
 * with explicit simulation headers and deterministic behavior.
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.MockTelecomAdapter = void 0;
class MockTelecomAdapter {
    static async activateSIM(req) {
        return {
            isSimulated: true,
            phoneNumber: `+1 (555) ${Math.floor(100 + Math.random() * 900)}-${Math.floor(1000 + Math.random() * 9000)}`,
            iccid: req.iccid,
            activationStatus: 'ACTIVATED',
            imsi: `310410${Math.floor(100000000 + Math.random() * 900000000)}`,
            timestamp: new Date().toISOString()
        };
    }
    static async provisionSpeedUpgrade(req) {
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
    static async processPayment(req) {
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
    static async sendTransactionalAlert(to, message) {
        return {
            isSimulated: true,
            messageId: `msg_${Date.now()}_${Math.random().toString(36).substring(2, 8)}`
        };
    }
}
exports.MockTelecomAdapter = MockTelecomAdapter;
