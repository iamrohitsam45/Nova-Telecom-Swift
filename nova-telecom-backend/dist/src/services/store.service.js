"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.StoreService = void 0;
const bcryptjs_1 = __importDefault(require("bcryptjs"));
class StoreService {
    static instance;
    users = [];
    refreshTokens = new Map(); // token -> userId
    products = [];
    plans = [];
    cartItems = new Map();
    orders = [];
    invoices = [];
    tickets = [];
    simCards = [];
    broadbands = [];
    dthAccounts = [];
    subscriptions = [];
    faqs = [];
    notifications = [];
    auditLogs = [];
    constructor() {
        this.seed();
    }
    static getInstance() {
        if (!StoreService.instance) {
            StoreService.instance = new StoreService();
        }
        return StoreService.instance;
    }
    seed() {
        const passwordHash = bcryptjs_1.default.hashSync('Password123!', 10);
        const demoUser = {
            id: 'usr_demo_8921',
            email: 'alex.mercer@novatelecom.io',
            passwordHash,
            fullName: 'Alex Mercer',
            phoneNumber: '+1 (555) 392-8821',
            role: 'CUSTOMER',
            customerSince: new Date(Date.now() - 365 * 24 * 3600 * 1000).toISOString()
        };
        this.users.push(demoUser);
        // 14 Products
        this.products = [
            {
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
                stockCount: 42,
                rating: 4.9,
                reviewCount: 318,
                imageUrl: 'wifi.router',
                model3DAsset: 'NovaRouterPro3D',
                isFeatured: true,
                wifiGeneration: 'Wi-Fi 7',
                maxSpeedMbps: 9600,
                ports: ['1x 10G SFP+ Fiber', '1x 10GbE WAN', '4x 2.5GbE LAN', '1x USB 3.2 Gen 2'],
                bands: ['2.4 GHz', '5.0 GHz', '6.0 GHz'],
                specifications: [
                    { key: 'Processor', value: 'Quad-Core ARM Cortex-A73 2.2GHz' },
                    { key: 'System Memory', value: '2GB DDR4 RAM + 512MB Flash' },
                    { key: 'Antennas', value: '6x External High-Gain Omni-directional' }
                ],
                reviews: [
                    { authorName: 'Marcus Vance', rating: 5, comment: 'Replaced my old box, latency dropped to 4ms!', date: '2026-10-12' }
                ]
            },
            {
                id: 'prod_mesh_orbit3',
                name: 'Nova Orbit Tri-Band Mesh System (3-Pack)',
                brand: 'NovaTech',
                category: 'MESH_WIFI',
                headline: 'Whole-Home Seamless Roaming Coverage Up to 7,500 sq ft',
                description: 'Eliminate dead zones with intelligent AI-powered mesh steering. Zero-drop handoff between rooms.',
                priceMinorUnits: 34999,
                discountMinorUnits: 4000,
                currency: 'USD',
                inStock: true,
                stockCount: 28,
                rating: 4.8,
                reviewCount: 194,
                imageUrl: 'network',
                model3DAsset: 'NovaMeshOrbit3D',
                isFeatured: true,
                wifiGeneration: 'Wi-Fi 6E',
                maxSpeedMbps: 5400,
                ports: ['3x 2.5GbE Ports per node'],
                bands: ['2.4 GHz', '5.0 GHz', '6.0 GHz'],
                specifications: [{ key: 'Coverage', value: 'Up to 7,500 sq ft' }],
                reviews: []
            },
            {
                id: 'prod_fiber_ont_xgs',
                name: 'Nova XGS-PON 10G Optical Network Terminal',
                brand: 'NovaTech',
                category: 'FIBER_ONT',
                headline: 'Symmetrical 10 Gigabit Ultra-Fiber Bridge',
                description: 'Ultra-low jitter bridge modem engineered for direct fiber termination.',
                priceMinorUnits: 14999,
                currency: 'USD',
                inStock: true,
                stockCount: 65,
                rating: 4.7,
                reviewCount: 88,
                imageUrl: 'cable.connector',
                model3DAsset: 'NovaFiberONT3D',
                isFeatured: false,
                maxSpeedMbps: 10000,
                ports: ['1x SC/APC Optical Port', '1x 10G Base-T RJ-45'],
                bands: [],
                specifications: [],
                reviews: []
            },
            {
                id: 'prod_hotspot_5g_pro',
                name: 'Nova Nomad 5G Ultra-Portable Hotspot',
                brand: 'NovaTech',
                category: 'PORTABLE_HOTSPOT',
                headline: 'Sub-6GHz and mmWave 5G Travel Router with 24hr Battery',
                description: 'Blazing fast cellular internet anywhere. 2.4-inch color touchscreen, Wi-Fi 6 for 32 devices.',
                priceMinorUnits: 24999,
                discountMinorUnits: 3000,
                currency: 'USD',
                inStock: true,
                stockCount: 35,
                rating: 4.8,
                reviewCount: 156,
                imageUrl: 'dot.radiowaves.left.and.right',
                model3DAsset: 'NovaHotspot5G3D',
                isFeatured: true,
                wifiGeneration: 'Wi-Fi 6',
                maxSpeedMbps: 3800,
                ports: ['1x USB-C 3.1 PD', '1x Nano-SIM Slot'],
                bands: ['Sub-6 5G', 'LTE-A Cat 20'],
                specifications: [],
                reviews: []
            },
            {
                id: 'prod_esim_starter',
                name: 'Nova 5G Global Travel eSIM Voucher',
                brand: 'Nova Mobile',
                category: 'SIM_ESIM',
                headline: 'Instant QR Activation with 20GB High-Speed Data in 120 Countries',
                description: 'Zero physical swap required. Download in seconds via QR code.',
                priceMinorUnits: 3500,
                currency: 'USD',
                inStock: true,
                stockCount: 999,
                rating: 4.9,
                reviewCount: 420,
                imageUrl: 'simcard',
                isFeatured: false,
                ports: [],
                bands: ['Global 5G & LTE'],
                specifications: [],
                reviews: []
            },
            {
                id: 'prod_dth_stream_box',
                name: 'Nova Smart 4K HDR DTH Set-Top Box',
                brand: 'Nova Vision',
                category: 'DTH_STB',
                headline: 'Hybrid Satellite & Android TV 14 Streaming Box with Dolby Atmos',
                description: 'Combines 400+ live satellite TV channels with all your streaming apps.',
                priceMinorUnits: 8999,
                discountMinorUnits: 1500,
                currency: 'USD',
                inStock: true,
                stockCount: 75,
                rating: 4.6,
                reviewCount: 230,
                imageUrl: 'tv',
                isFeatured: true,
                wifiGeneration: 'Wi-Fi 6',
                maxSpeedMbps: 1200,
                ports: ['1x LNB Satellite In', '1x HDMI 2.1 eARC', '1x Optical Audio'],
                bands: ['2.4 GHz', '5.0 GHz'],
                specifications: [],
                reviews: []
            },
            {
                id: 'prod_cat8_cable',
                name: 'Nova Ultra Shielded Cat 8 Ethernet Cable (10m)',
                brand: 'NovaTech',
                category: 'ACCESSORIES',
                headline: '40Gbps 2000MHz Double Shielded SFTP Gold-Plated RJ45',
                description: 'Heavy duty pure copper oxygen-free wiring for extreme low interference.',
                priceMinorUnits: 2499,
                currency: 'USD',
                inStock: true,
                stockCount: 150,
                rating: 4.9,
                reviewCount: 88,
                imageUrl: 'cable.coaxial',
                isFeatured: false,
                ports: ['Gold-plated RJ-45'],
                bands: [],
                specifications: [],
                reviews: []
            },
            {
                id: 'prod_fiber_patch_sc',
                name: 'Nova Armored Fiber SC/APC to SC/APC Cable (5m)',
                brand: 'NovaTech',
                category: 'FIBER_EQUIPMENT',
                headline: 'Bend-Insensitive Single Mode Simplex Optical Fiber Patch Cord',
                description: 'Steel-braided armored optical cable prevents accidental crushing.',
                priceMinorUnits: 1999,
                currency: 'USD',
                inStock: true,
                stockCount: 120,
                rating: 4.7,
                reviewCount: 64,
                imageUrl: 'point.3.filled.connected.trianglepath.dotted',
                isFeatured: false,
                ports: ['SC/APC Optical Connector'],
                bands: [],
                specifications: [],
                reviews: []
            },
            {
                id: 'prod_sim_duo',
                name: 'Nova 5G Triple-Cut Physical SIM Kit',
                brand: 'Nova Mobile',
                category: 'SIM_ESIM',
                headline: 'Universal Standard, Micro, and Nano SIM with $10 Recharge Bonus',
                description: 'Ready for any unlocked smartphone or tablet.',
                priceMinorUnits: 999,
                currency: 'USD',
                inStock: true,
                stockCount: 500,
                rating: 4.5,
                reviewCount: 95,
                imageUrl: 'simcard.2',
                isFeatured: false,
                ports: [],
                bands: [],
                specifications: [],
                reviews: []
            },
            {
                id: 'prod_wifi_extender',
                name: 'Nova RangeMax Dual-Band Wi-Fi 6 Wall Plug Extender',
                brand: 'NovaTech',
                category: 'WIFI_ROUTERS',
                headline: 'Gigabit Wall Plug Wi-Fi Repeater with External Antennas',
                description: 'Plugs directly into any wall outlet. Extends existing router by 2,000 sq ft.',
                priceMinorUnits: 6999,
                discountMinorUnits: 1000,
                currency: 'USD',
                inStock: true,
                stockCount: 80,
                rating: 4.4,
                reviewCount: 142,
                imageUrl: 'antenna.radiowaves.left.and.right',
                isFeatured: false,
                wifiGeneration: 'Wi-Fi 6',
                maxSpeedMbps: 1800,
                ports: ['1x Gigabit Ethernet'],
                bands: ['2.4 GHz', '5.0 GHz'],
                specifications: [],
                reviews: []
            },
            {
                id: 'prod_mesh_node_single',
                name: 'Nova Orbit Add-On Satellite Node',
                brand: 'NovaTech',
                category: 'MESH_WIFI',
                headline: 'Expand Your Existing Nova Orbit Mesh System by 2,500 sq ft',
                description: 'One-touch WPS sync with existing Orbit network.',
                priceMinorUnits: 12999,
                currency: 'USD',
                inStock: true,
                stockCount: 40,
                rating: 4.8,
                reviewCount: 76,
                imageUrl: 'network',
                isFeatured: false,
                wifiGeneration: 'Wi-Fi 6E',
                maxSpeedMbps: 5400,
                ports: ['2x 2.5GbE LAN'],
                bands: ['2.4 GHz', '5.0 GHz', '6.0 GHz'],
                specifications: [],
                reviews: []
            },
            {
                id: 'prod_ups_router',
                name: 'Nova Mini-UPS 12V Router Power Backup (4 Hours)',
                brand: 'NovaTech',
                category: 'ACCESSORIES',
                headline: 'Uninterrupted Internet Power During Outages with 10,000mAh Battery',
                description: 'Keep your optical ONT and router running seamlessly when power fails.',
                priceMinorUnits: 4999,
                discountMinorUnits: 800,
                currency: 'USD',
                inStock: true,
                stockCount: 95,
                rating: 4.8,
                reviewCount: 180,
                imageUrl: 'battery.100.bolt',
                isFeatured: false,
                ports: ['1x 12V DC Out', '1x USB 5V Out'],
                bands: [],
                specifications: [],
                reviews: []
            },
            {
                id: 'prod_hotspot_lite',
                name: 'Nova Pocket 4G LTE Hotspot',
                brand: 'Nova Mobile',
                category: 'PORTABLE_HOTSPOT',
                headline: 'Compact Everyday Mobile Wi-Fi for Up to 10 Devices',
                description: '150Mbps download, 10 hours battery life.',
                priceMinorUnits: 5999,
                currency: 'USD',
                inStock: true,
                stockCount: 60,
                rating: 4.3,
                reviewCount: 110,
                imageUrl: 'dot.radiowaves.left.and.right',
                isFeatured: false,
                wifiGeneration: 'Wi-Fi 5',
                maxSpeedMbps: 150,
                ports: ['1x Micro-USB', '1x Micro-SIM'],
                bands: ['LTE Bands 1/3/7/20'],
                specifications: [],
                reviews: []
            },
            {
                id: 'prod_dth_universal_remote',
                name: 'Nova Voice Bluetooth Universal DTH Remote',
                brand: 'Nova Vision',
                category: 'ACCESSORIES',
                headline: 'Backlit Bluetooth 5.2 Voice Remote with Dedicated Streaming Buttons',
                description: 'Compatible with all Nova DTH STBs and 99% of smart televisions.',
                priceMinorUnits: 1999,
                currency: 'USD',
                inStock: true,
                stockCount: 200,
                rating: 4.6,
                reviewCount: 67,
                imageUrl: 'mic.fill',
                isFeatured: false,
                ports: [],
                bands: [],
                specifications: [],
                reviews: []
            }
        ];
        // 15 Plans
        this.plans = [
            {
                id: 'plan_mob_prep_unlimited',
                name: 'Nova 5G Ultra Max',
                type: 'MOBILE_PREPAID',
                headline: 'Unlimited True 5G Data with Free National Roaming',
                priceMinorUnits: 2999,
                currency: 'USD',
                billingCycleDays: 30,
                downloadSpeedMbps: 850,
                uploadSpeedMbps: 120,
                isUnlimitedData: true,
                callingAllowance: 'Unlimited Calls (Local + STD + Roaming)',
                smsAllowance: '100 SMS / Day',
                routerIncluded: false,
                installationFeeMinorUnits: 0,
                bundledOTTApps: ['Disney+ Hotstar', 'Nova Music Pro'],
                features: [
                    { id: 'f1', title: 'Unlimited High-Speed 5G', isHighlighted: true },
                    { id: 'f2', title: 'Free Weekend Data Rollover', isHighlighted: false }
                ],
                isPopular: true,
                isBestValue: false
            },
            {
                id: 'plan_mob_prep_daily',
                name: 'Nova 5G Daily Flex',
                type: 'MOBILE_PREPAID',
                headline: '2.5 GB / Day High Speed Data + Unlimited Calling',
                priceMinorUnits: 1999,
                currency: 'USD',
                billingCycleDays: 30,
                downloadSpeedMbps: 600,
                uploadSpeedMbps: 90,
                dataQuotaGB: 75.0,
                isUnlimitedData: false,
                callingAllowance: 'Unlimited Local & National',
                smsAllowance: '100 SMS / Day',
                routerIncluded: false,
                installationFeeMinorUnits: 0,
                bundledOTTApps: [],
                features: [
                    { id: 'f3', title: '2.5GB High-Speed Daily Quota', isHighlighted: true },
                    { id: 'f4', title: 'Night Binge 12AM-6AM Free', isHighlighted: true }
                ],
                isPopular: false,
                isBestValue: true
            },
            {
                id: 'plan_mob_prep_annual',
                name: 'Nova 5G Annual Sovereign',
                type: 'MOBILE_PREPAID',
                headline: '365-Day Long-Term Plan with 2.5GB/Day & Prime Video Included',
                priceMinorUnits: 19999,
                currency: 'USD',
                billingCycleDays: 365,
                downloadSpeedMbps: 850,
                uploadSpeedMbps: 120,
                dataQuotaGB: 912.5,
                isUnlimitedData: false,
                callingAllowance: 'Unlimited All Networks 365 Days',
                smsAllowance: '100 SMS / Day',
                routerIncluded: false,
                installationFeeMinorUnits: 0,
                bundledOTTApps: ['Prime Video 1 Year', 'Disney+ Mobile'],
                features: [
                    { id: 'f5', title: 'Full 365 Days Validity', isHighlighted: true },
                    { id: 'f6', title: 'VIP Support Priority', isHighlighted: false }
                ],
                isPopular: false,
                isBestValue: false
            },
            {
                id: 'plan_mob_post_family',
                name: 'Nova Postpaid Family Infinity',
                type: 'MOBILE_POSTPAID',
                headline: '4 Family SIM Connections with 250GB Shared Pool',
                priceMinorUnits: 7999,
                currency: 'USD',
                billingCycleDays: 30,
                downloadSpeedMbps: 950,
                uploadSpeedMbps: 140,
                dataQuotaGB: 250.0,
                isUnlimitedData: false,
                callingAllowance: 'Unlimited Calls for 4 SIMs',
                smsAllowance: 'Unlimited SMS',
                routerIncluded: false,
                installationFeeMinorUnits: 0,
                bundledOTTApps: ['Netflix Standard', 'Prime Video', 'Disney+'],
                features: [{ id: 'f7', title: '4 Included SIM Cards', isHighlighted: true }],
                isPopular: true,
                isBestValue: false
            },
            {
                id: 'plan_mob_post_individual',
                name: 'Nova Postpaid Solo Prime',
                type: 'MOBILE_POSTPAID',
                headline: '75GB Monthly Data Rollover + Netflix Included',
                priceMinorUnits: 3999,
                currency: 'USD',
                billingCycleDays: 30,
                downloadSpeedMbps: 850,
                uploadSpeedMbps: 120,
                dataQuotaGB: 75.0,
                isUnlimitedData: false,
                callingAllowance: 'Unlimited Calling',
                smsAllowance: '100 SMS / Day',
                routerIncluded: false,
                installationFeeMinorUnits: 0,
                bundledOTTApps: ['Netflix Basic'],
                features: [{ id: 'f8', title: 'Zero Bill Shock Guarantee', isHighlighted: false }],
                isPopular: false,
                isBestValue: false
            },
            {
                id: 'plan_fiber_300',
                name: 'Nova Fiber Essential 300',
                type: 'BROADBAND_FIBER',
                headline: '300 Mbps Symmetrical Fiber with Free Wi-Fi 6 Router',
                priceMinorUnits: 4999,
                currency: 'USD',
                billingCycleDays: 30,
                downloadSpeedMbps: 300,
                uploadSpeedMbps: 300,
                isUnlimitedData: true,
                routerIncluded: true,
                installationFeeMinorUnits: 0,
                bundledOTTApps: [],
                features: [
                    { id: 'f9', title: '300 Mbps Symmetrical Speed', isHighlighted: true },
                    { id: 'f10', title: 'Free Wi-Fi 6 Router', isHighlighted: true }
                ],
                isPopular: false,
                isBestValue: false
            },
            {
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
                installationFeeMinorUnits: 0,
                bundledOTTApps: ['Netflix 4K', 'Disney+ Premium', 'Prime Video', 'Max'],
                features: [
                    { id: 'f11', title: '1 Gbps True Fiber Line Speed', isHighlighted: true },
                    { id: 'f12', title: 'Included Nova WiFi 7 Mesh Gateway Pro', isHighlighted: true },
                    { id: 'f13', title: '4 Top OTT Subscriptions Included', isHighlighted: true }
                ],
                isPopular: true,
                isBestValue: true
            },
            {
                id: 'plan_fiber_2500',
                name: 'Nova Fiber Extreme 2.5 Gbps',
                type: 'BROADBAND_FIBER',
                headline: '2,500 Mbps Multi-Gigabit Fiber with 10G Optical Terminal',
                priceMinorUnits: 12999,
                currency: 'USD',
                billingCycleDays: 30,
                downloadSpeedMbps: 2500,
                uploadSpeedMbps: 2500,
                isUnlimitedData: true,
                routerIncluded: true,
                installationFeeMinorUnits: 0,
                bundledOTTApps: ['Netflix 4K', 'Disney+ Premium', 'Prime Video', 'Apple TV+', 'Max'],
                features: [
                    { id: 'f14', title: '2,500 Mbps Line Rate', isHighlighted: true },
                    { id: 'f15', title: 'Sub-2ms Gaming Core Latency', isHighlighted: true }
                ],
                isPopular: false,
                isBestValue: false
            },
            {
                id: 'plan_fiber_100',
                name: 'Nova Fiber Starter 100',
                type: 'BROADBAND_FIBER',
                headline: '100 Mbps Reliable Fiber for Everyday Work and Streaming',
                priceMinorUnits: 2999,
                currency: 'USD',
                billingCycleDays: 30,
                downloadSpeedMbps: 100,
                uploadSpeedMbps: 100,
                isUnlimitedData: true,
                routerIncluded: true,
                installationFeeMinorUnits: 1999,
                bundledOTTApps: [],
                features: [{ id: 'f16', title: '100 Mbps Unlimited Data', isHighlighted: false }],
                isPopular: false,
                isBestValue: false
            },
            {
                id: 'plan_dth_sports_movies',
                name: 'Nova DTH 4K Sports & Cinema',
                type: 'DTH_TV',
                headline: '380+ Channels with 85 HD & 4K Live Sports Channels',
                priceMinorUnits: 2499,
                currency: 'USD',
                billingCycleDays: 30,
                dthChannelCount: 380,
                hdChannelCount: 85,
                routerIncluded: false,
                installationFeeMinorUnits: 0,
                bundledOTTApps: [],
                features: [
                    { id: 'f17', title: 'All Major Sports in 4K HDR', isHighlighted: true },
                    { id: 'f18', title: 'Catch-up TV 7 Days Included', isHighlighted: false }
                ],
                isPopular: true,
                isBestValue: false
            },
            {
                id: 'plan_dth_family_hd',
                name: 'Nova DTH Family Delight HD',
                type: 'DTH_TV',
                headline: '280+ Family, Kids, News, and Documentary Channels',
                priceMinorUnits: 1799,
                currency: 'USD',
                billingCycleDays: 30,
                dthChannelCount: 280,
                hdChannelCount: 50,
                routerIncluded: false,
                installationFeeMinorUnits: 0,
                bundledOTTApps: [],
                features: [{ id: 'f19', title: 'Kids & Documentaries', isHighlighted: false }],
                isPopular: false,
                isBestValue: false
            },
            {
                id: 'plan_dth_mega_all',
                name: 'Nova DTH Sovereign All-Access',
                type: 'DTH_TV',
                headline: '500+ Complete Channel Universe Including International Feeds',
                priceMinorUnits: 3499,
                currency: 'USD',
                billingCycleDays: 30,
                dthChannelCount: 510,
                hdChannelCount: 120,
                routerIncluded: false,
                installationFeeMinorUnits: 0,
                bundledOTTApps: [],
                features: [{ id: 'f20', title: 'Every HD & 4K Satellite Channel', isHighlighted: true }],
                isPopular: false,
                isBestValue: false
            },
            {
                id: 'plan_ott_netflix_4k',
                name: 'Netflix Premium 4K HDR',
                type: 'STREAMING_OTT',
                headline: 'Watch on 4 Supported Devices at Once in 4K Ultra HD & Spatial Audio',
                priceMinorUnits: 1999,
                currency: 'USD',
                billingCycleDays: 30,
                routerIncluded: false,
                installationFeeMinorUnits: 0,
                bundledOTTApps: ['Netflix'],
                features: [{ id: 'f21', title: '4 Simultaneous 4K HDR Streams', isHighlighted: true }],
                isPopular: true,
                isBestValue: false
            },
            {
                id: 'plan_ott_disney_bundle',
                name: 'Disney+ & Hulu Bundle',
                type: 'STREAMING_OTT',
                headline: 'Endless Entertainment from Disney, Pixar, Marvel, Star Wars & Hulu',
                priceMinorUnits: 1499,
                currency: 'USD',
                billingCycleDays: 30,
                routerIncluded: false,
                installationFeeMinorUnits: 0,
                bundledOTTApps: ['Disney+', 'Hulu'],
                features: [{ id: 'f22', title: 'Ad-Free Streaming on Both', isHighlighted: true }],
                isPopular: false,
                isBestValue: false
            },
            {
                id: 'plan_ott_prime_music',
                name: 'Amazon Prime Video & Music',
                type: 'STREAMING_OTT',
                headline: 'Award-winning Amazon Originals with Free Fast Delivery Privileges',
                priceMinorUnits: 1299,
                currency: 'USD',
                billingCycleDays: 30,
                routerIncluded: false,
                installationFeeMinorUnits: 0,
                bundledOTTApps: ['Prime Video', 'Amazon Music'],
                features: [{ id: 'f23', title: 'Prime Delivery Privileges', isHighlighted: false }],
                isPopular: false,
                isBestValue: false
            }
        ];
        // Seed SIMs
        this.simCards = [
            {
                id: 'sim_primary_8821',
                phoneNumber: '+1 (555) 392-8821',
                iccid: '8901410321111851072',
                isEsim: true,
                balanceMinorUnits: 1850,
                dataRemainingGB: 34.6,
                dataTotalGB: 50.0,
                expiryDate: new Date(Date.now() + 18 * 24 * 3600 * 1000).toISOString(),
                planName: 'Nova 5G Ultra Max',
                is5GActive: true,
                status: 'ACTIVE'
            }
        ];
        // Seed Broadband
        this.broadbands = [
            {
                id: 'conn_fiber_9042',
                serviceIdentifier: 'NOVA-FIBER-9042',
                planName: 'Gigabit Fiber Pro 1000',
                downloadSpeedMbps: 1000,
                uploadSpeedMbps: 1000,
                isOnline: true,
                wifiSsid: 'NovaFiber_5G_Home',
                routerModel: 'Nova WiFi 7 Mesh Gateway Pro',
                ipAddress: '192.168.1.1',
                dataUsedGB: 412.5,
                dataTotalGB: 1000.0,
                nextBillAmountMinorUnits: 7999,
                connectionState: 'ONLINE'
            }
        ];
        // Seed DTH
        this.dthAccounts = [
            {
                id: 'dth_984210',
                subscriberNumber: 'DTH-984210',
                smartCardNumber: '4029-8812-7491',
                packageName: 'Nova 4K Ultra Sports & Movies',
                activeTillDate: new Date(Date.now() + 24 * 24 * 3600 * 1000).toISOString(),
                monthlyFeeMinorUnits: 2499,
                totalChannels: 380,
                isActive: true
            }
        ];
        // Seed Subscriptions
        this.subscriptions = [
            {
                id: 'sub_netflix_01',
                providerName: 'Netflix Premium 4K',
                tierDescription: 'Included with Gigabit Fiber 1000',
                monthlyValueMinorUnits: 1999,
                isActivated: true,
                renewalDate: new Date(Date.now() + 14 * 24 * 3600 * 1000).toISOString()
            },
            {
                id: 'sub_disney_02',
                providerName: 'Disney+ Hotstar',
                tierDescription: 'Included with 5G Ultra Max',
                monthlyValueMinorUnits: 1499,
                isActivated: true,
                renewalDate: new Date(Date.now() + 22 * 24 * 3600 * 1000).toISOString()
            }
        ];
        // Seed Invoices
        this.invoices = [
            {
                id: 'inv_2026_10',
                invoiceNumber: 'INV-2026-10492',
                billingPeriodStart: new Date(Date.now() - 30 * 24 * 3600 * 1000).toISOString(),
                billingPeriodEnd: new Date().toISOString(),
                dueDate: new Date(Date.now() + 12 * 24 * 3600 * 1000).toISOString(),
                totalAmountMinorUnits: 10498,
                status: 'PAID',
                paymentMethod: 'Apple Pay (MasterCard •• 8812)',
                lineItems: [
                    { description: 'Nova Gigabit Fiber Pro 1000', amountMinorUnits: 7999 },
                    { description: 'Nova DTH 4K Sports & Cinema', amountMinorUnits: 2499 }
                ],
                pdfDownloadUrl: 'https://novatelecom.io/invoices/INV-2026-10492.pdf'
            }
        ];
        // Seed Orders
        this.orders = [
            {
                id: 'ord_9921',
                orderNumber: 'ORD-9921-881',
                createdAt: new Date(Date.now() - 2 * 24 * 3600 * 1000).toISOString(),
                status: 'SHIPPED',
                items: [
                    { productId: 'prod_cat8_cable', productName: 'Nova Ultra Shielded Cat 8 Ethernet Cable', quantity: 2, unitPriceMinorUnits: 2499 }
                ],
                totalAmountMinorUnits: 4998,
                shippingAddress: { street: '742 Evergreen Terrace', city: 'San Francisco', state: 'CA', postalCode: '94107' },
                trackingNumber: 'NOVA-TRK-88492019US',
                estimatedDeliveryDate: new Date(Date.now() + 24 * 3600 * 1000).toISOString()
            }
        ];
        // Seed Support Tickets
        this.tickets = [
            {
                id: 'tck_8821',
                ticketNumber: 'TCK-8821-01',
                title: 'Optic Signal Calibration Check',
                category: 'Broadband Diagnostics',
                priority: 'MEDIUM',
                status: 'IN_PROGRESS',
                createdAt: new Date(Date.now() - 6 * 3600 * 1000).toISOString(),
                updatedAt: new Date(Date.now() - 45 * 60 * 1000).toISOString(),
                messages: [
                    { sender: 'Alex Mercer', isFromUser: true, message: 'Ran the 3D modem troubleshooting wizard. Optical RX level is -22dBm.', timestamp: new Date(Date.now() - 6 * 3600 * 1000).toISOString() },
                    { sender: 'Nova Automated Diagnostics', isFromUser: false, message: 'Automated line test trace: SFP optical transceiver within normal limits.', timestamp: new Date(Date.now() - 5 * 3600 * 1000).toISOString() }
                ]
            }
        ];
        // Seed FAQs
        this.faqs = [
            {
                id: 'faq_1',
                question: 'How do I interpret the indicator LEDs on my Nova router?',
                answer: 'Solid cyan means normal online operation. Pulsing cyan indicates IP acquisition. Flickering signifies active Wi-Fi data transfer. Amber or red indicates line or authentication issues.',
                category: 'Hardware & LEDs'
            },
            {
                id: 'faq_2',
                question: 'How do I upgrade my broadband speed?',
                answer: 'Navigate to the Plans tab, select Upgrade Speed, and choose your tier. Symmetrical optical fiber speeds are provisioned digitally within 15 minutes without technician dispatch.',
                category: 'Broadband & Plans'
            }
        ];
    }
}
exports.StoreService = StoreService;
