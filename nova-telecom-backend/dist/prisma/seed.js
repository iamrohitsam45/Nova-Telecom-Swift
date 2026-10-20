"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const client_1 = require("@prisma/client");
const bcryptjs_1 = __importDefault(require("bcryptjs"));
const prisma = new client_1.PrismaClient();
async function main() {
    console.log('🌱 Starting Nova Telecom database seed...');
    const passwordHash = await bcryptjs_1.default.hash('Password123!', 10);
    // 1. Create Demo User
    const user = await prisma.user.upsert({
        where: { email: 'alex.mercer@novatelecom.io' },
        update: {},
        create: {
            email: 'alex.mercer@novatelecom.io',
            fullName: 'Alex Mercer',
            phoneNumber: '+1 (555) 392-8821',
            passwordHash,
            role: 'CUSTOMER',
            profile: {
                create: {
                    preferredLang: 'en',
                    preferredCurr: 'USD',
                    biometricLogin: true
                }
            },
            addresses: {
                create: {
                    label: 'Home',
                    street: '742 Evergreen Terrace',
                    apartment: 'Suite 4B',
                    city: 'San Francisco',
                    state: 'CA',
                    postalCode: '94107',
                    country: 'US',
                    isDefault: true
                }
            }
        }
    });
    console.log(`✅ Seeded user: ${user.email} (${user.id})`);
    // 2. Create Products
    const routerProduct = await prisma.product.upsert({
        where: { id: 'prod_router_pro7' },
        update: {},
        create: {
            id: 'prod_router_pro7',
            name: 'Nova WiFi 7 Mesh Gateway Pro',
            brand: 'NovaTech',
            category: 'WIFI_ROUTERS',
            headline: 'Flagship Tri-Band Wi-Fi 7 with 10Gbps Fiber Optical Port',
            description: 'Experience extreme wireless throughput up to 9.6 Gbps. Features 6 active beamforming antennas, quad-core 2.2GHz processor, 10GbE WAN, 4x 2.5GbE LAN ports, and integrated SC/APC fiber optic ONT transceiver.',
            priceMinorUnits: 29999,
            discountMinorUnits: 5000,
            currency: 'USD',
            inStock: true,
            model3DAsset: 'NovaRouterPro3D',
            isFeatured: true,
            wifiGeneration: 'Wi-Fi 7',
            maxSpeedMbps: 9600,
            portsJson: JSON.stringify(['1x 10G SFP+ Fiber', '1x 10GbE WAN', '4x 2.5GbE LAN', '1x USB 3.2 Gen 2']),
            bandsJson: JSON.stringify(['2.4 GHz', '5.0 GHz', '6.0 GHz']),
            specifications: {
                create: [
                    { specKey: 'Processor', specValue: 'Quad-Core ARM Cortex-A73 2.2GHz' },
                    { specKey: 'RAM', specValue: '2GB DDR4' }
                ]
            }
        }
    });
    console.log(`✅ Seeded primary 3D router product: ${routerProduct.name}`);
    // 3. Create Plans
    const fiberPlan = await prisma.plan.upsert({
        where: { id: 'plan_fiber_1000' },
        update: {},
        create: {
            id: 'plan_fiber_1000',
            name: 'Nova Fiber Pro Gigabit 1000',
            type: 'BROADBAND_FIBER',
            headline: '1,000 Mbps Ultra-Speed with Tri-Band Mesh Gateway',
            priceMinorUnits: 7999,
            currency: 'USD',
            billingCycleDays: 30,
            downloadSpeedMbps: 1000,
            uploadSpeedMbps: 1000,
            isUnlimitedData: true,
            routerIncluded: true,
            bundledOTTAppsJson: JSON.stringify(['Netflix 4K', 'Disney+ Premium', 'Prime Video']),
            isPopular: true,
            isBestValue: true,
            features: {
                create: [
                    { title: '1 Gbps True Fiber Line Speed', isHighlighted: true },
                    { title: 'Included Nova WiFi 7 Mesh Gateway Pro', isHighlighted: true }
                ]
            }
        }
    });
    console.log(`✅ Seeded fiber plan: ${fiberPlan.name}`);
    console.log('🎉 Database seeding complete!');
}
main()
    .catch((e) => {
    console.error('Seed script notice:', e.message);
})
    .finally(async () => {
    await prisma.$disconnect();
});
