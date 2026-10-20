import Foundation

public final class DemoDataStore: @unchecked Sendable {
    public static let shared = DemoDataStore()

    public private(set) var products: [Product] = []
    public private(set) var plans: [Plan] = []
    public private(set) var simCards: [SIMCard] = []
    public private(set) var broadbandConnection: BroadbandConnection
    public private(set) var dthAccount: DTHAccount
    public private(set) var streamingSubscriptions: [StreamingSubscription] = []
    public var cart: Cart = Cart()
    public private(set) var orders: [Order] = []
    public private(set) var invoices: [Invoice] = []
    public private(set) var supportTickets: [SupportTicket] = []
    public private(set) var faqs: [FAQItem] = []

    public struct FAQItem: Identifiable, Codable, Equatable, Sendable {
        public let id: String
        public let question: String
        public let answer: String
        public let category: String

        public init(id: String = UUID().uuidString, question: String, answer: String, category: String) {
            self.id = id
            self.question = question
            self.answer = answer
            self.category = category
        }
    }

    private init() {
        self.broadbandConnection = BroadbandConnection(
            id: "conn_fiber_9042",
            serviceIdentifier: "NOVA-FIBER-9042",
            planName: "Gigabit Fiber Pro 1000",
            downloadSpeedMbps: 1000,
            uploadSpeedMbps: 1000,
            isOnline: true,
            wifiSsid: "NovaFiber_5G_Home",
            routerModel: "Nova WiFi 7 Mesh Gateway Pro",
            ipAddress: "192.168.1.1",
            dataUsedGB: 412.5,
            dataTotalGB: 1000.0,
            nextBillAmountMinorUnits: 7999,
            connectionState: .online
        )

        self.dthAccount = DTHAccount(
            id: "dth_984210",
            subscriberNumber: "DTH-984210",
            smartCardNumber: "4029-8812-7491",
            packageName: "Nova 4K Ultra Sports & Movies",
            activeTillDate: Calendar.current.date(byAdding: .day, value: 24, to: Date()) ?? Date(),
            monthlyFeeMinorUnits: 2499,
            totalChannels: 380,
            isActive: true
        )

        loadSampleData()
    }

    private func loadSampleData() {
        // 1. PRODUCTS (14 diverse items spanning all required categories)
        products = [
            Product(
                id: "prod_router_pro7",
                name: "Nova WiFi 7 Mesh Gateway Pro",
                brand: "NovaTech",
                category: .wifiRouters,
                headline: "Flagship Tri-Band Wi-Fi 7 with 10Gbps Fiber Optical Port",
                description: "Experience extreme wireless throughput up to 9.6 Gbps. Features 6 active beamforming antennas, quad-core 2.2GHz processor, 10GbE WAN, 4x 2.5GbE LAN ports, and integrated SC/APC fiber optic ONT transceiver.",
                priceMinorUnits: 29999,
                discountMinorUnits: 5000,
                stockCount: 42,
                rating: 4.9,
                reviewCount: 318,
                imageUrl: "wifi.router",
                model3DAsset: "NovaRouterPro3D",
                isFeatured: true,
                wifiGeneration: "Wi-Fi 7",
                maxSpeedMbps: 9600,
                ports: ["1x 10G SFP+ Fiber", "1x 10GbE WAN", "4x 2.5GbE LAN", "1x USB 3.2 Gen 2"],
                bands: ["2.4 GHz (1376 Mbps)", "5.0 GHz (5764 Mbps)", "6.0 GHz (11520 Mbps)"],
                specifications: [
                    ProductSpecification(key: "Processor", value: "Quad-Core ARM Cortex-A73 2.2GHz"),
                    ProductSpecification(key: "System Memory", value: "2GB DDR4 RAM + 512MB Flash"),
                    ProductSpecification(key: "Antennas", value: "6x External High-Gain Omni-directional"),
                    ProductSpecification(key: "Security", value: "WPA3-Enterprise, Nova Shield Cyber Defense"),
                    ProductSpecification(key: "Power Supply", value: "12V / 3.5A DC Adapter")
                ],
                reviews: [
                    ProductReview(authorName: "Marcus Vance", rating: 5.0, comment: "Replaced my old ISP box. Latency dropped to 4ms in competitive games. Outstanding Wi-Fi 7 range!"),
                    ProductReview(authorName: "Elena Rostova", rating: 4.8, comment: "The 3D interactive port guide in the app made setup effortless. Sleek design.")
                ]
            ),
            Product(
                id: "prod_mesh_orbit3",
                name: "Nova Orbit Tri-Band Mesh System (3-Pack)",
                brand: "NovaTech",
                category: .meshWifi,
                headline: "Whole-Home Seamless Roaming Coverage Up to 7,500 sq ft",
                description: "Eliminate dead zones with intelligent AI-powered mesh steering. Zero-drop handoff between rooms, dedicated 5GHz wireless backhaul, and parental controls.",
                priceMinorUnits: 34999,
                discountMinorUnits: 4000,
                stockCount: 28,
                rating: 4.8,
                reviewCount: 194,
                imageUrl: "network",
                model3DAsset: "NovaMeshOrbit3D",
                isFeatured: true,
                wifiGeneration: "Wi-Fi 6E",
                maxSpeedMbps: 5400,
                ports: ["3x 2.5GbE Ports per node"],
                bands: ["2.4 GHz", "5.0 GHz", "6.0 GHz"],
                specifications: [
                    ProductSpecification(key: "Coverage", value: "Up to 7,500 sq ft"),
                    ProductSpecification(key: "Max Connected Devices", value: "250+ Devices"),
                    ProductSpecification(key: "Backhaul", value: "Dedicated 6GHz Band or Ethernet")
                ]
            ),
            Product(
                id: "prod_fiber_ont_xgs",
                name: "Nova XGS-PON 10G Optical Network Terminal",
                brand: "NovaTech",
                category: .fiberONT,
                headline: "Symmetrical 10 Gigabit Ultra-Fiber Bridge",
                description: "Ultra-low jitter bridge modem engineered for direct fiber termination. Provides line-rate 10Gbps optical to Ethernet conversion for high-demand homelabs and studios.",
                priceMinorUnits: 14999,
                stockCount: 65,
                rating: 4.7,
                reviewCount: 88,
                imageUrl: "cable.connector",
                model3DAsset: "NovaFiberONT3D",
                isFeatured: false,
                wifiGeneration: nil,
                maxSpeedMbps: 10000,
                ports: ["1x SC/APC Optical Port", "1x 10G Base-T RJ-45", "1x 1G RJ-45 Mgmt"],
                bands: []
            ),
            Product(
                id: "prod_hotspot_5g_pro",
                name: "Nova Nomad 5G Ultra-Portable Hotspot",
                brand: "NovaTech",
                category: .portableHotspot,
                headline: "Sub-6GHz and mmWave 5G Travel Router with 24hr Battery",
                description: "Blazing fast cellular internet anywhere. 2.4-inch color touchscreen, Wi-Fi 6 for 32 devices simultaneously, 8000mAh battery with power-bank charging output.",
                priceMinorUnits: 24999,
                discountMinorUnits: 3000,
                stockCount: 35,
                rating: 4.8,
                reviewCount: 156,
                imageUrl: "dot.radiowaves.left.and.right",
                model3DAsset: "NovaHotspot5G3D",
                isFeatured: true,
                wifiGeneration: "Wi-Fi 6",
                maxSpeedMbps: 3800,
                ports: ["1x USB-C 3.1 PD", "1x Nano-SIM Slot", "2x TS-9 External Antenna Ports"],
                bands: ["Sub-6 5G (n1/n3/n7/n28/n77/n78)", "LTE-A Cat 20"]
            ),
            Product(
                id: "prod_esim_starter",
                name: "Nova 5G Global Travel eSIM Voucher",
                brand: "Nova Mobile",
                category: .simAndEsim,
                headline: "Instant QR Activation with 20GB High-Speed Data in 120 Countries",
                description: "Zero physical swap required. Download in seconds via QR code, auto-connect to the strongest tier-1 LTE/5G local network worldwide.",
                priceMinorUnits: 3500,
                stockCount: 999,
                rating: 4.9,
                reviewCount: 420,
                imageUrl: "simcard",
                model3DAsset: nil,
                isFeatured: false,
                wifiGeneration: nil,
                maxSpeedMbps: 1200,
                ports: [],
                bands: ["Global 5G & LTE"]
            ),
            Product(
                id: "prod_dth_stream_box",
                name: "Nova Smart 4K HDR DTH Set-Top Box",
                brand: "Nova Vision",
                category: .dthSetTopBox,
                headline: "Hybrid Satellite & Android TV 14 Streaming Box with Dolby Atmos",
                description: "Combines 400+ live satellite TV channels with all your streaming apps (Netflix, Prime, Disney+). Voice remote with Google Assistant, optical audio output, and USB PVR recording.",
                priceMinorUnits: 8999,
                discountMinorUnits: 1500,
                stockCount: 75,
                rating: 4.6,
                reviewCount: 230,
                imageUrl: "tv",
                model3DAsset: "NovaSetTopBox3D",
                isFeatured: true,
                wifiGeneration: "Wi-Fi 6",
                maxSpeedMbps: 1200,
                ports: ["1x LNB Satellite In", "1x HDMI 2.1 eARC", "1x Optical Audio", "1x Ethernet RJ45", "2x USB 2.0"],
                bands: ["2.4 GHz", "5.0 GHz"]
            ),
            Product(
                id: "prod_cat8_cable",
                name: "Nova Ultra Shielded Cat 8 Ethernet Cable (10m)",
                brand: "NovaTech",
                category: .accessories,
                headline: "40Gbps 2000MHz Double Shielded SFTP Gold-Plated RJ45",
                description: "Heavy duty pure copper oxygen-free wiring designed for extreme low interference in gaming and 10Gbps fiber router backhauls.",
                priceMinorUnits: 2499,
                stockCount: 150,
                rating: 4.9,
                reviewCount: 88,
                imageUrl: "cable.coaxial",
                model3DAsset: nil,
                isFeatured: false,
                wifiGeneration: nil,
                maxSpeedMbps: 40000,
                ports: ["Gold-plated RJ-45"],
                bands: []
            ),
            Product(
                id: "prod_fiber_patch_sc",
                name: "Nova Armored Fiber SC/APC to SC/APC Cable (5m)",
                brand: "NovaTech",
                category: .fiberEquipment,
                headline: "Bend-Insensitive Single Mode Simplex Optical Fiber Patch Cord",
                description: "Steel-braided armored optical cable prevents accidental crushing, pet chewing, or severe bends. Clean 0.2dB insertion loss.",
                priceMinorUnits: 1999,
                stockCount: 120,
                rating: 4.7,
                reviewCount: 64,
                imageUrl: "point.3.filled.connected.trianglepath.dotted",
                model3DAsset: nil,
                isFeatured: false,
                wifiGeneration: nil,
                maxSpeedMbps: 100000,
                ports: ["SC/APC Optical Connector"],
                bands: []
            ),
            Product(
                id: "prod_sim_duo",
                name: "Nova 5G Triple-Cut Physical SIM Kit",
                brand: "Nova Mobile",
                category: .simAndEsim,
                headline: "Universal Standard, Micro, and Nano SIM with $10 Recharge Bonus",
                description: "Ready for any unlocked smartphone or tablet. Includes welcome bonus, caller ID, and high-speed nationwide 5G access.",
                priceMinorUnits: 999,
                stockCount: 500,
                rating: 4.5,
                reviewCount: 95,
                imageUrl: "simcard.2",
                model3DAsset: nil,
                isFeatured: false,
                wifiGeneration: nil,
                maxSpeedMbps: 1500,
                ports: [],
                bands: []
            ),
            Product(
                id: "prod_wifi_extender",
                name: "Nova RangeMax Dual-Band Wi-Fi 6 Wall Plug Extender",
                brand: "NovaTech",
                category: .wifiRouters,
                headline: "Gigabit Wall Plug Wi-Fi Repeater with External Antennas",
                description: "Plugs directly into any wall outlet. Extends your existing router Wi-Fi by 2,000 sq ft with Smart Signal LED indicators.",
                priceMinorUnits: 6999,
                discountMinorUnits: 1000,
                stockCount: 80,
                rating: 4.4,
                reviewCount: 142,
                imageUrl: "antenna.radiowaves.left.and.right",
                model3DAsset: nil,
                isFeatured: false,
                wifiGeneration: "Wi-Fi 6",
                maxSpeedMbps: 1800,
                ports: ["1x Gigabit Ethernet"],
                bands: ["2.4 GHz", "5.0 GHz"]
            ),
            Product(
                id: "prod_mesh_node_single",
                name: "Nova Orbit Add-On Satellite Node",
                brand: "NovaTech",
                category: .meshWifi,
                headline: "Expand Your Existing Nova Orbit Mesh System by 2,500 sq ft",
                description: "One-touch WPS sync with existing Orbit network. Seamless roaming and 2 extra gigabit LAN ports for smart TVs or gaming consoles.",
                priceMinorUnits: 12999,
                stockCount: 40,
                rating: 4.8,
                reviewCount: 76,
                imageUrl: "network",
                model3DAsset: nil,
                isFeatured: false,
                wifiGeneration: "Wi-Fi 6E",
                maxSpeedMbps: 5400,
                ports: ["2x 2.5GbE LAN"],
                bands: ["2.4 GHz", "5.0 GHz", "6.0 GHz"]
            ),
            Product(
                id: "prod_ups_router",
                name: "Nova Mini-UPS 12V Router Power Backup (4 Hours)",
                brand: "NovaTech",
                category: .accessories,
                headline: "Uninterrupted Internet Power During Outages with 10,000mAh Battery",
                description: "Keep your optical ONT and Wi-Fi router running seamlessly when power fails. Zero-second transfer time guarantees video calls never drop.",
                priceMinorUnits: 4999,
                discountMinorUnits: 800,
                stockCount: 95,
                rating: 4.8,
                reviewCount: 180,
                imageUrl: "battery.100.bolt",
                model3DAsset: nil,
                isFeatured: false,
                wifiGeneration: nil,
                maxSpeedMbps: nil,
                ports: ["1x 12V DC Out", "1x 9V DC Out", "1x USB 5V Out"],
                bands: []
            ),
            Product(
                id: "prod_hotspot_lite",
                name: "Nova Pocket 4G LTE Hotspot",
                brand: "Nova Mobile",
                category: .portableHotspot,
                headline: "Compact Everyday Mobile Wi-Fi for Up to 10 Devices",
                description: "150Mbps download, 10 hours continuous battery life. Ideal for students, remote workers, and road trips.",
                priceMinorUnits: 5999,
                stockCount: 60,
                rating: 4.3,
                reviewCount: 110,
                imageUrl: "dot.radiowaves.left.and.right",
                model3DAsset: nil,
                isFeatured: false,
                wifiGeneration: "Wi-Fi 5",
                maxSpeedMbps: 150,
                ports: ["1x Micro-USB", "1x Micro-SIM"],
                bands: ["LTE Bands 1/3/5/7/8/20"]
            ),
            Product(
                id: "prod_dth_universal_remote",
                name: "Nova Voice Bluetooth Universal DTH Remote",
                brand: "Nova Vision",
                category: .accessories,
                headline: "Backlit Bluetooth 5.2 Voice Remote with Dedicated Streaming Buttons",
                description: "Compatible with all Nova DTH STBs and 99% of smart televisions. Features motion-activated backlighting and programmable IR learning.",
                priceMinorUnits: 1999,
                stockCount: 200,
                rating: 4.6,
                reviewCount: 67,
                imageUrl: "mic.fill",
                model3DAsset: nil,
                isFeatured: false,
                wifiGeneration: nil,
                maxSpeedMbps: nil,
                ports: [],
                bands: []
            )
        ]

        // 2. PLANS (15 comprehensive plans across all 5 telecom categories)
        plans = [
            // Mobile Prepaid
            Plan(
                id: "plan_mob_prep_unlimited",
                name: "Nova 5G Ultra Max",
                type: .mobilePrepaid,
                headline: "Unlimited True 5G Data with Free National Roaming",
                priceMinorUnits: 2999,
                billingCycleDays: 30,
                downloadSpeedMbps: 850,
                uploadSpeedMbps: 120,
                dataQuotaGB: nil,
                isUnlimitedData: true,
                callingAllowance: "Unlimited Calls (Local + STD + Roaming)",
                smsAllowance: "100 SMS / Day",
                bundledOTTApps: ["Disney+ Hotstar", "Nova Music Pro"],
                features: [
                    PlanFeature(title: "Unlimited High-Speed 5G", isHighlighted: true),
                    PlanFeature(title: "Free Weekend Data Rollover", isHighlighted: false),
                    PlanFeature(title: "5GB High-Speed Hotspot Sharing", isHighlighted: false),
                    PlanFeature(title: "Spam Call & SMS Shield Included", isHighlighted: false)
                ],
                isPopular: true,
                isBestValue: false
            ),
            Plan(
                id: "plan_mob_prep_daily",
                name: "Nova 5G Daily Flex",
                type: .mobilePrepaid,
                headline: "2.5 GB / Day High Speed Data + Unlimited Calling",
                priceMinorUnits: 1999,
                billingCycleDays: 30,
                downloadSpeedMbps: 600,
                uploadSpeedMbps: 90,
                dataQuotaGB: 75.0,
                isUnlimitedData: false,
                callingAllowance: "Unlimited Local & National",
                smsAllowance: "100 SMS / Day",
                features: [
                    PlanFeature(title: "2.5GB High-Speed Daily Quota", isHighlighted: true),
                    PlanFeature(title: "Unlimited Night Surfing (12 AM - 6 AM)", isHighlighted: true),
                    PlanFeature(title: "eSIM Compatible", isHighlighted: false)
                ],
                isPopular: false,
                isBestValue: true
            ),
            Plan(
                id: "plan_mob_prep_annual",
                name: "Nova 5G Annual Sovereign",
                type: .mobilePrepaid,
                headline: "365-Day Long-Term Plan with 2.5GB/Day & Prime Video Included",
                priceMinorUnits: 19999,
                billingCycleDays: 365,
                downloadSpeedMbps: 850,
                uploadSpeedMbps: 120,
                dataQuotaGB: 912.5,
                isUnlimitedData: false,
                callingAllowance: "Unlimited All Networks 365 Days",
                smsAllowance: "100 SMS / Day",
                bundledOTTApps: ["Prime Video 1 Year", "Disney+ Mobile"],
                features: [
                    PlanFeature(title: "Full 365 Days Validity", isHighlighted: true),
                    PlanFeature(title: "Save $40 Compared to Monthly", isHighlighted: true),
                    PlanFeature(title: "VIP Support Queue", isHighlighted: false)
                ]
            ),
            // Mobile Postpaid
            Plan(
                id: "plan_mob_post_family",
                name: "Nova Postpaid Family Infinity",
                type: .mobilePostpaid,
                headline: "4 Family SIM Connections with 250GB Shared Pool",
                priceMinorUnits: 7999,
                billingCycleDays: 30,
                downloadSpeedMbps: 950,
                uploadSpeedMbps: 140,
                dataQuotaGB: 250.0,
                isUnlimitedData: false,
                callingAllowance: "Unlimited Calls for all 4 SIMs",
                smsAllowance: "Unlimited SMS",
                bundledOTTApps: ["Netflix Standard", "Prime Video", "Disney+"],
                features: [
                    PlanFeature(title: "4 Included SIM Cards (1 Primary + 3 Add-on)", isHighlighted: true),
                    PlanFeature(title: "500GB Data Rollover Cap", isHighlighted: true),
                    PlanFeature(title: "International Roaming 100 mins free", isHighlighted: false)
                ],
                isPopular: true
            ),
            Plan(
                id: "plan_mob_post_individual",
                name: "Nova Postpaid Solo Prime",
                type: .mobilePostpaid,
                headline: "75GB Monthly Data Rollover + Netflix Included",
                priceMinorUnits: 3999,
                billingCycleDays: 30,
                downloadSpeedMbps: 850,
                uploadSpeedMbps: 120,
                dataQuotaGB: 75.0,
                isUnlimitedData: false,
                callingAllowance: "Unlimited Calling",
                smsAllowance: "100 SMS / Day",
                bundledOTTApps: ["Netflix Basic", "Nova Cloud 100GB"],
                features: [
                    PlanFeature(title: "Zero Bill Shock Guarantee", isHighlighted: false),
                    PlanFeature(title: "Free SIM Home Delivery & eSIM Swap", isHighlighted: false)
                ]
            ),
            // Broadband Fiber
            Plan(
                id: "plan_fiber_300",
                name: "Nova Fiber Essential 300",
                type: .broadbandFiber,
                headline: "300 Mbps Symmetrical Fiber with Free Wi-Fi 6 Router",
                priceMinorUnits: 4999,
                billingCycleDays: 30,
                downloadSpeedMbps: 300,
                uploadSpeedMbps: 300,
                dataQuotaGB: nil,
                isUnlimitedData: true,
                routerIncluded: true,
                installationFeeMinorUnits: 0,
                features: [
                    PlanFeature(title: "300 Mbps Symmetrical Upload/Download", isHighlighted: true),
                    PlanFeature(title: "Free Dual-Band Wi-Fi 6 Router", isHighlighted: true),
                    PlanFeature(title: "Zero Installation Fee on Annual / 6-Mo", isHighlighted: false),
                    PlanFeature(title: "99.9% Uptime SLA", isHighlighted: false)
                ]
            ),
            Plan(
                id: "plan_fiber_1000",
                name: "Nova Fiber Pro Gigabit 1000",
                type: .broadbandFiber,
                headline: "1,000 Mbps Ultra-Speed with Tri-Band Mesh Gateway",
                priceMinorUnits: 7999,
                billingCycleDays: 30,
                downloadSpeedMbps: 1000,
                uploadSpeedMbps: 1000,
                dataQuotaGB: nil,
                isUnlimitedData: true,
                routerIncluded: true,
                installationFeeMinorUnits: 0,
                bundledOTTApps: ["Netflix 4K", "Disney+ Premium", "Prime Video", "Max"],
                features: [
                    PlanFeature(title: "1 Gbps True Fiber Line Speed", isHighlighted: true),
                    PlanFeature(title: "Included Nova WiFi 7 Mesh Gateway Pro", isHighlighted: true),
                    PlanFeature(title: "4 Top OTT Subscriptions Included", isHighlighted: true),
                    PlanFeature(title: "Static IPv4 Available", isHighlighted: false),
                    PlanFeature(title: "Free 4K DTH Smart Box Connection", isHighlighted: false)
                ],
                isPopular: true,
                isBestValue: true
            ),
            Plan(
                id: "plan_fiber_2500",
                name: "Nova Fiber Extreme 2.5 Gbps",
                type: .broadbandFiber,
                headline: "2,500 Mbps Multi-Gigabit Fiber with 10G Optical Terminal",
                priceMinorUnits: 12999,
                billingCycleDays: 30,
                downloadSpeedMbps: 2500,
                uploadSpeedMbps: 2500,
                dataQuotaGB: nil,
                isUnlimitedData: true,
                routerIncluded: true,
                installationFeeMinorUnits: 0,
                bundledOTTApps: ["Netflix 4K", "Disney+ Premium", "Prime Video", "Apple TV+", "Max"],
                features: [
                    PlanFeature(title: "2,500 Mbps Ultra Multi-Gig Line", isHighlighted: true),
                    PlanFeature(title: "Sub-2ms Gaming Core Latency", isHighlighted: true),
                    PlanFeature(title: "Dual Mesh 7 Satellite Nodes Included", isHighlighted: true),
                    PlanFeature(title: "Dedicated 24/7 Priority Fiber Dispatch", isHighlighted: false)
                ]
            ),
            Plan(
                id: "plan_fiber_100",
                name: "Nova Fiber Starter 100",
                type: .broadbandFiber,
                headline: "100 Mbps Reliable Fiber for Everyday Work and Streaming",
                priceMinorUnits: 2999,
                billingCycleDays: 30,
                downloadSpeedMbps: 100,
                uploadSpeedMbps: 100,
                dataQuotaGB: nil,
                isUnlimitedData: true,
                routerIncluded: true,
                installationFeeMinorUnits: 1999,
                features: [
                    PlanFeature(title: "100 Mbps Unlimited Data", isHighlighted: false),
                    PlanFeature(title: "Wi-Fi 5 Router Included", isHighlighted: false)
                ]
            ),
            // DTH Television Plans
            Plan(
                id: "plan_dth_sports_movies",
                name: "Nova DTH 4K Sports & Cinema",
                type: .dthTelevision,
                headline: "380+ Channels with 85 HD & 4K Live Sports Channels",
                priceMinorUnits: 2499,
                billingCycleDays: 30,
                dthChannelCount: 380,
                hdChannelCount: 85,
                features: [
                    PlanFeature(title: "All Major Sports in 4K HDR", isHighlighted: true),
                    PlanFeature(title: "English & Regional Movie Networks", isHighlighted: false),
                    PlanFeature(title: "Interactive TV Guide & 7-Day Catch-up", isHighlighted: false)
                ],
                isPopular: true
            ),
            Plan(
                id: "plan_dth_family_hd",
                name: "Nova DTH Family Delight HD",
                type: .dthTelevision,
                headline: "280+ Family, Kids, News, and Documentary Channels",
                priceMinorUnits: 1799,
                billingCycleDays: 30,
                dthChannelCount: 280,
                hdChannelCount: 50,
                features: [
                    PlanFeature(title: "National Geographic, Discovery & History", isHighlighted: false),
                    PlanFeature(title: "Kids Entertainment & Cartoon Networks", isHighlighted: false)
                ]
            ),
            Plan(
                id: "plan_dth_mega_all",
                name: "Nova DTH Sovereign All-Access",
                type: .dthTelevision,
                headline: "500+ Complete Channel Universe Including International Feeds",
                priceMinorUnits: 3499,
                billingCycleDays: 30,
                dthChannelCount: 510,
                hdChannelCount: 120,
                features: [
                    PlanFeature(title: "Every Single HD & 4K Satellite Channel", isHighlighted: true),
                    PlanFeature(title: "Multi-TV Secondary Box Connection Free", isHighlighted: true)
                ]
            ),
            // Streaming Subscriptions
            Plan(
                id: "plan_ott_netflix_4k",
                name: "Netflix Premium 4K HDR",
                type: .streamingOTT,
                headline: "Watch on 4 Supported Devices at Once in 4K Ultra HD & Spatial Audio",
                priceMinorUnits: 1999,
                billingCycleDays: 30,
                bundledOTTApps: ["Netflix"],
                features: [
                    PlanFeature(title: "4 Simultaneous 4K HDR Streams", isHighlighted: true),
                    PlanFeature(title: "Download on 6 Devices", isHighlighted: false),
                    PlanFeature(title: "Billed Directly on Nova Telecom Invoice", isHighlighted: true)
                ]
            ),
            Plan(
                id: "plan_ott_disney_bundle",
                name: "Disney+ & Hulu Bundle",
                type: .streamingOTT,
                headline: "Endless Entertainment from Disney, Pixar, Marvel, Star Wars & Hulu",
                priceMinorUnits: 1499,
                billingCycleDays: 30,
                bundledOTTApps: ["Disney+", "Hulu"],
                features: [
                    PlanFeature(title: "Ad-Free Streaming on Both Services", isHighlighted: true),
                    PlanFeature(title: "Save 30% Compared to Individual Bills", isHighlighted: false)
                ]
            ),
            Plan(
                id: "plan_ott_prime_music",
                name: "Amazon Prime Video & Music",
                type: .streamingOTT,
                headline: "Award-winning Amazon Originals with Free Fast Delivery Privileges",
                priceMinorUnits: 1299,
                billingCycleDays: 30,
                bundledOTTApps: ["Prime Video", "Amazon Music"],
                features: [
                    PlanFeature(title: "Prime Shopping Benefits Linked to Mobile", isHighlighted: false)
                ]
            )
        ]

        // 3. SIM CARDS
        simCards = [
            SIMCard(
                id: "sim_primary_8821",
                phoneNumber: "+1 (555) 392-8821",
                iccid: "8901410321111851072",
                isEsim: true,
                balanceMinorUnits: 1850,
                dataRemainingGB: 34.6,
                dataTotalGB: 50.0,
                expiryDate: Calendar.current.date(byAdding: .day, value: 18, to: Date()) ?? Date(),
                planName: "Nova 5G Ultra Max",
                is5GActive: true,
                status: "ACTIVE"
            ),
            SIMCard(
                id: "sim_secondary_4910",
                phoneNumber: "+1 (555) 741-9943",
                iccid: "8901410321111851099",
                isEsim: false,
                balanceMinorUnits: 500,
                dataRemainingGB: 12.0,
                dataTotalGB: 25.0,
                expiryDate: Calendar.current.date(byAdding: .day, value: 8, to: Date()) ?? Date(),
                planName: "Nova 5G Daily Flex",
                is5GActive: true,
                status: "ACTIVE"
            )
        ]

        // 4. STREAMING SUBSCRIPTIONS
        streamingSubscriptions = [
            StreamingSubscription(
                id: "sub_netflix_01",
                providerName: "Netflix Premium 4K",
                iconUrl: "play.rectangle.fill",
                isActivated: true,
                renewalDate: Calendar.current.date(byAdding: .day, value: 14, to: Date()) ?? Date(),
                tierDescription: "Included with Gigabit Fiber 1000",
                monthlyValueMinorUnits: 1999
            ),
            StreamingSubscription(
                id: "sub_disney_02",
                providerName: "Disney+ Hotstar",
                iconUrl: "sparkles.tv.fill",
                isActivated: true,
                renewalDate: Calendar.current.date(byAdding: .day, value: 22, to: Date()) ?? Date(),
                tierDescription: "Included with 5G Ultra Max",
                monthlyValueMinorUnits: 1499
            ),
            StreamingSubscription(
                id: "sub_prime_03",
                providerName: "Prime Video",
                iconUrl: "tv.fill",
                isActivated: false,
                renewalDate: Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date(),
                tierDescription: "Eligible for 1-click activation",
                monthlyValueMinorUnits: 1299
            )
        ]

        // 5. INVOICES
        invoices = [
            Invoice(
                id: "inv_2026_10",
                invoiceNumber: "INV-2026-10492",
                billingPeriodStart: Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date(),
                billingPeriodEnd: Date(),
                dueDate: Calendar.current.date(byAdding: .day, value: 12, to: Date()) ?? Date(),
                totalAmountMinorUnits: 10498,
                status: .paid,
                paymentMethod: "Apple Pay (MasterCard •• 8812)",
                lineItems: [
                    InvoiceLineItem(description: "Nova Gigabit Fiber Pro 1000 (Monthly)", amountMinorUnits: 7999),
                    InvoiceLineItem(description: "Nova DTH 4K Sports & Cinema", amountMinorUnits: 2499)
                ],
                pdfDownloadUrl: "https://novatelecom.io/invoices/INV-2026-10492.pdf"
            ),
            Invoice(
                id: "inv_2026_09",
                invoiceNumber: "INV-2026-09281",
                billingPeriodStart: Calendar.current.date(byAdding: .day, value: -60, to: Date()) ?? Date(),
                billingPeriodEnd: Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date(),
                dueDate: Calendar.current.date(byAdding: .day, value: -18, to: Date()) ?? Date(),
                totalAmountMinorUnits: 10498,
                status: .paid,
                paymentMethod: "Visa ending in 4242",
                lineItems: [
                    InvoiceLineItem(description: "Nova Gigabit Fiber Pro 1000 (Monthly)", amountMinorUnits: 7999),
                    InvoiceLineItem(description: "Nova DTH 4K Sports & Cinema", amountMinorUnits: 2499)
                ],
                pdfDownloadUrl: "https://novatelecom.io/invoices/INV-2026-09281.pdf"
            )
        ]

        // 6. ORDERS
        orders = [
            Order(
                id: "ord_9921",
                orderNumber: "ORD-9921-881",
                createdAt: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
                status: .shipped,
                items: [
                    OrderItem(productId: "prod_cat8_cable", productName: "Nova Ultra Shielded Cat 8 Ethernet Cable", quantity: 2, unitPriceMinorUnits: 2499),
                    OrderItem(productId: "prod_ups_router", productName: "Nova Mini-UPS 12V Router Backup", quantity: 1, unitPriceMinorUnits: 4199)
                ],
                totalAmountMinorUnits: 9197,
                shippingAddress: Address(
                    street: "742 Evergreen Terrace",
                    apartment: "Suite 4B",
                    city: "San Francisco",
                    state: "CA",
                    postalCode: "94107"
                ),
                trackingNumber: "NOVA-TRK-88492019US",
                estimatedDeliveryDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())
            )
        ]

        // 7. SUPPORT TICKETS
        supportTickets = [
            SupportTicket(
                id: "tck_8821",
                ticketNumber: "TCK-8821-01",
                title: "Optic Signal Calibration Check",
                category: "Broadband Diagnostics",
                priority: .medium,
                status: .inProgress,
                createdAt: Calendar.current.date(byAdding: .hour, value: -6, to: Date()) ?? Date(),
                updatedAt: Calendar.current.date(byAdding: .minute, value: -45, to: Date()) ?? Date(),
                messages: [
                    SupportMessage(
                        sender: "Alex Mercer",
                        isFromUser: true,
                        message: "Ran the 3D modem troubleshooting wizard. Optical power RX was showing -22dBm. Requesting line telemetry check.",
                        timestamp: Calendar.current.date(byAdding: .hour, value: -6, to: Date()) ?? Date()
                    ),
                    SupportMessage(
                        sender: "Nova Automated Diagnostics",
                        isFromUser: false,
                        message: "Automated line test initiated: SFP optical transceiver reports signal within acceptable standard (-18dBm to -24dBm). Fiber link is healthy.",
                        timestamp: Calendar.current.date(byAdding: .hour, value: -5, to: Date()) ?? Date()
                    ),
                    SupportMessage(
                        sender: "Sarah Jenkins (Field Engineer)",
                        isFromUser: false,
                        message: "Hi Alex, I checked the OLT port in your neighborhood hub. Firmware on your Nova Mesh Gateway was updated to 4.2.1-patch2. Speeds are verified at 980Mbps.",
                        timestamp: Calendar.current.date(byAdding: .minute, value: -45, to: Date()) ?? Date()
                    )
                ],
                scheduledAppointment: Calendar.current.date(byAdding: .day, value: 3, to: Date())
            )
        ]

        // 8. FAQS
        faqs = [
            FAQItem(
                question: "How do I interpret the indicator LEDs on my Nova router?",
                answer: "The Power LED solid cyan means normal operation. The Internet LED pulses cyan while acquiring an IP address and remains steady cyan when online. The 2.4G and 5G LEDs flicker softly during active Wi-Fi data transmission. An amber or red LED indicates an optical fiber or physical cable issue.",
                category: "Hardware & LEDs"
            ),
            FAQItem(
                question: "How do I upgrade my broadband speed?",
                answer: "Navigate to the Plans tab or the Broadband section, select 'Upgrade Speed', choose your desired speed tier (e.g. 1 Gbps or 2.5 Gbps), and tap confirm. Symmetrical fiber speed upgrades are provisioned digitally within 15 minutes without requiring a technician visit.",
                category: "Broadband & Plans"
            ),
            FAQItem(
                question: "How do I activate an eSIM on my iPhone?",
                answer: "After purchasing an eSIM plan, go to Profile > Linked SIMs and tap 'Install eSIM'. Scan the QR code or tap 'Add Cellular Plan' to download the carrier profile directly into iOS Settings > Cellular.",
                category: "SIM & eSIM"
            ),
            FAQItem(
                question: "What should I do if my Wi-Fi is slow?",
                answer: "Open Support > Internet Troubleshooting Wizard. The app tests latency to your local gateway, checks optical fiber RX levels, and inspects channel congestion. In 80% of cases, toggling the 5GHz/6GHz band steering optimizes speeds instantly.",
                category: "Troubleshooting"
            )
        ]
    }

    // MARK: - API Dispatcher for Demo Simulation
    @MainActor
    public func handleDemoRequest<T: Decodable>(endpoint: APIEndpoint, body: (any Encodable)?) async throws -> T {
        // Small realistic simulated delay (150ms to 400ms)
        try? await Task.sleep(nanoseconds: 200_000_000)

        switch endpoint {
        case .getProducts(let category, let query):
            var filtered = products
            if let cat = category {
                filtered = filtered.filter { $0.category == cat }
            }
            if let q = query, !q.isEmpty {
                filtered = filtered.filter { $0.name.localizedCaseInsensitiveContains(q) || $0.description.localizedCaseInsensitiveContains(q) }
            }
            if let result = filtered as? T { return result }

        case .getProductDetails(let id):
            if let product = products.first(where: { $0.id == id }) as? T {
                return product
            }

        case .getPlans(let type):
            var filtered = plans
            if let t = type {
                filtered = filtered.filter { $0.type == t }
            }
            if let result = filtered as? T { return result }

        case .getSimCards:
            if let result = simCards as? T { return result }

        case .getBroadbandConnections:
            if let result = [broadbandConnection] as? T { return result }

        case .getDTHAccounts:
            if let result = [dthAccount] as? T { return result }

        case .getSubscriptions:
            if let result = streamingSubscriptions as? T { return result }

        case .getCart:
            if let result = cart as? T { return result }

        case .getOrders:
            if let result = orders as? T { return result }

        case .getInvoices:
            if let result = invoices as? T { return result }

        case .getTickets:
            if let result = supportTickets as? T { return result }

        case .getFAQs:
            if let result = faqs as? T { return result }

        default:
            break
        }

        // Generic fallback decoding if T matches common types
        if let dummy = try? JSONDecoder().decode(T.self, from: "{}".data(using: .utf8)!) {
            return dummy
        }

        throw NetworkError.demoModeFallback
    }

    // MARK: - Cart Mutations
    public func addToCart(product: Product, quantity: Int = 1) {
        if let index = cart.items.firstIndex(where: { $0.product.id == product.id }) {
            cart.items[index].quantity += quantity
        } else {
            cart.items.append(CartItem(product: product, quantity: quantity))
        }
    }

    public func updateCartItemQuantity(id: String, quantity: Int) {
        if let index = cart.items.firstIndex(where: { $0.id == id }) {
            if quantity <= 0 {
                cart.items.remove(at: index)
            } else {
                cart.items[index].quantity = quantity
            }
        }
    }

    public func removeCartItem(id: String) {
        cart.items.removeAll(where: { $0.id == id })
    }

    public func clearCart() {
        cart.items.removeAll()
        cart.promoCode = nil
        cart.promoDiscountMinorUnits = 0
    }

    // MARK: - Checkout & Actions
    public func placeOrder(address: Address) -> Order {
        let orderItems = cart.items.map {
            OrderItem(productId: $0.product.id, productName: $0.product.name, quantity: $0.quantity, unitPriceMinorUnits: $0.product.effectivePriceMinorUnits)
        }
        let total = cart.grandTotalMinorUnits
        let newOrder = Order(
            orderNumber: "ORD-\(Int.random(in: 1000...9999))-\(Int.random(in: 100...999))",
            createdAt: Date(),
            status: .processing,
            items: orderItems,
            totalAmountMinorUnits: total,
            shippingAddress: address,
            trackingNumber: "NOVA-TRK-\(UUID().uuidString.prefix(8).uppercased())US",
            estimatedDeliveryDate: Calendar.current.date(byAdding: .day, value: 2, to: Date())
        )
        orders.insert(newOrder, at: 0)
        clearCart()
        return newOrder
    }

    public func rechargeSIM(simId: String, amountMinorUnits: Int, dataGB: Double) {
        if let idx = simCards.firstIndex(where: { $0.id == simId }) {
            simCards[idx].balanceMinorUnits += amountMinorUnits
            simCards[idx].dataRemainingGB += dataGB
            simCards[idx].expiryDate = Calendar.current.date(byAdding: .day, value: 30, to: simCards[idx].expiryDate) ?? Date()
        }
    }

    public func upgradeBroadbandSpeed(newDownloadMbps: Int, newUploadMbps: Int, planName: String) {
        broadbandConnection.downloadSpeedMbps = newDownloadMbps
        broadbandConnection.uploadSpeedMbps = newUploadMbps
        broadbandConnection.planName = planName
    }

    public func toggleSubscription(id: String, activate: Bool) {
        if let idx = streamingSubscriptions.firstIndex(where: { $0.id == id }) {
            streamingSubscriptions[idx].isActivated = activate
        }
    }

    public func addSupportTicket(title: String, category: String, message: String, priority: TicketPriority) -> SupportTicket {
        let ticket = SupportTicket(
            ticketNumber: "TCK-\(Int.random(in: 1000...9999))-01",
            title: title,
            category: category,
            priority: priority,
            status: .open,
            createdAt: Date(),
            updatedAt: Date(),
            messages: [
                SupportMessage(sender: "Alex Mercer", isFromUser: true, message: message, timestamp: Date()),
                SupportMessage(sender: "Nova AI Agent", isFromUser: false, message: "Thank you for reaching out. We have received your service inquiry and a diagnostic trace has been attached to ticket. Our network operations team is reviewing.", timestamp: Date())
            ]
        )
        supportTickets.insert(ticket, at: 0)
        return ticket
    }
}
