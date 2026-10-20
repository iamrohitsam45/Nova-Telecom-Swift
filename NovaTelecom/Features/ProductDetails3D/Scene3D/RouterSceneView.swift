import SwiftUI
import SceneKit

public enum CameraPerspective: String, CaseIterable, Identifiable, Sendable {
    case isometric = "3D Angle"
    case front = "Front LEDs"
    case rearPorts = "Rear Ports"
    case antennas = "Antennas"
    case top = "Top View"

    public var id: String { rawValue }

    var cameraPosition: SCNVector3 {
        switch self {
        case .isometric:
            return SCNVector3(x: 5.5, y: 4.5, z: 6.5)
        case .front:
            return SCNVector3(x: 0, y: 1.0, z: 6.8)
        case .rearPorts:
            return SCNVector3(x: 0, y: 0.8, z: -6.8)
        case .antennas:
            return SCNVector3(x: 0, y: 5.8, z: 4.0)
        case .top:
            return SCNVector3(x: 0, y: 8.5, z: 0.1)
        }
    }

    var cameraEulerAngles: SCNVector3 {
        switch self {
        case .isometric:
            return SCNVector3(-0.45, 0.65, 0)
        case .front:
            return SCNVector3(-0.12, 0, 0)
        case .rearPorts:
            return SCNVector3(-0.10, Float.pi, 0)
        case .antennas:
            return SCNVector3(-0.9, 0, 0)
        case .top:
            return SCNVector3(-Float.pi / 2, 0, 0)
        }
    }
}

public struct RouterSceneView: View {
    @Binding public var connectionState: ConnectionState
    @Binding public var currentPerspective: CameraPerspective
    @State private var selectedHotspot: RouterHotspot?
    @State private var scene: SCNScene = SCNScene()
    @State private var cameraNode: SCNNode = SCNNode()
    @State private var routerRootNode: SCNNode?

    // Gesture Tracking
    @State private var rotationY: Float = 0.0
    @State private var rotationX: Float = 0.0
    @State private var zoomScale: CGFloat = 1.0

    private let hotspots: [RouterHotspot] = [
        RouterHotspot(
            id: "spot_fiber",
            title: "SC/APC Optical Port",
            subtitle: "10 Gbps Symmetrical Fiber In",
            details: "Direct single-mode optical fiber termination. Connects directly to the neighborhood Optical Line Terminal (OLT) without needing an external ONT bridge.",
            icon: "cable.connector",
            screenPosition: CGPoint(x: 0.28, y: 0.58),
            portType: .fiberSC
        ),
        RouterHotspot(
            id: "spot_wan",
            title: "10GbE WAN Uplink",
            subtitle: "Ultra High-Bandwidth RJ45",
            details: "10 Gigabit Ethernet WAN port for multi-gigabit broadband backhauls or failover cellular gateway connections.",
            icon: "network",
            screenPosition: CGPoint(x: 0.42, y: 0.58),
            portType: .wan10G
        ),
        RouterHotspot(
            id: "spot_lan",
            title: "4x 2.5GbE LAN Array",
            subtitle: "Multi-Gigabit Device Ports",
            details: "Four dedicated 2.5Gbps Ethernet ports engineered for high-performance gaming rigs, NAS storage, and 4K streaming TVs.",
            icon: "laptopcomputer.and.ipad",
            screenPosition: CGPoint(x: 0.58, y: 0.58),
            portType: .lan25G
        ),
        RouterHotspot(
            id: "spot_antennas",
            title: "Beamforming Antennas",
            subtitle: "6x High-Gain Multi-Band Masts",
            details: "Tri-Band Wi-Fi 7 array with active 4K-QAM beamforming and Multi-Link Operation (MLO) for zero-latency concurrent transmission.",
            icon: "antenna.radiowaves.left.and.right",
            screenPosition: CGPoint(x: 0.50, y: 0.25),
            portType: .antennas
        ),
        RouterHotspot(
            id: "spot_leds",
            title: "Status Diagnostics",
            subtitle: "Multicolor Emissive LEDs",
            details: "Real-time hardware status indicators for Power, Internet uplink, 2.4/5/6 GHz wireless activity, and VoIP telemetry.",
            icon: "circle.grid.2x1.fill",
            screenPosition: CGPoint(x: 0.50, y: 0.68),
            portType: .statusLEDs
        )
    ]

    public init(
        connectionState: Binding<ConnectionState>,
        currentPerspective: Binding<CameraPerspective>
    ) {
        self._connectionState = connectionState
        self._currentPerspective = currentPerspective
    }

    public var body: some View {
        ZStack {
            // 3D SceneKit View
            SceneView(
                scene: scene,
                pointOfView: cameraNode,
                options: [.allowsCameraControl]
            )
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let deltaY = Float(value.translation.width) * 0.005
                        let deltaX = Float(value.translation.height) * 0.005
                        routerRootNode?.eulerAngles.y = rotationY + deltaY
                        routerRootNode?.eulerAngles.x = rotationX + deltaX
                    }
                    .onEnded { value in
                        rotationY += Float(value.translation.width) * 0.005
                        rotationX += Float(value.translation.height) * 0.005
                    }
            )
            .background(TelecomColors.deepNavy)

            // Hotspots layer
            RouterHotspotOverlay(
                hotspots: hotspots,
                selectedHotspot: $selectedHotspot
            )

            // Perspective switch pill row
            VStack {
                HStack(spacing: 8) {
                    ForEach(CameraPerspective.allCases) { perspective in
                        Button(action: {
                            HapticFeedback.light()
                            currentPerspective = perspective
                            animateCamera(to: perspective)
                        }) {
                            Text(perspective.rawValue)
                                .font(TelecomTypography.captionSmall)
                                .foregroundColor(currentPerspective == perspective ? .white : TelecomColors.neutralMuted)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(
                                    currentPerspective == perspective
                                    ? TelecomColors.electricBlue
                                    : Color.white.opacity(0.08)
                                )
                                .clipShape(Capsule())
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.black.opacity(0.4))
                .clipShape(Capsule())
                .padding(.top, 12)

                Spacer()
            }
        }
        .onAppear {
            setupScene()
        }
        .onChange(of: connectionState) { newState in
            updateConnectionState(newState)
        }
    }

    private func setupScene() {
        let newScene = SCNScene()

        // 1. Camera Node
        let cam = SCNCamera()
        cam.zNear = 0.1
        cam.zFar = 100
        cam.fieldOfView = 48
        cameraNode = SCNNode()
        cameraNode.camera = cam
        cameraNode.position = currentPerspective.cameraPosition
        cameraNode.eulerAngles = currentPerspective.cameraEulerAngles
        newScene.rootNode.addChildNode(cameraNode)

        // 2. Lighting Setup
        // Key Light (Crisp directional)
        let keyLight = SCNLight()
        keyLight.type = .directional
        keyLight.color = UIColor.white
        keyLight.intensity = 1000
        keyLight.castsShadow = true
        let keyLightNode = SCNNode()
        keyLightNode.light = keyLight
        keyLightNode.position = SCNVector3(x: 5, y: 10, z: 8)
        keyLightNode.eulerAngles = SCNVector3(-0.7, 0.5, 0)
        newScene.rootNode.addChildNode(keyLightNode)

        // Rim Light (Cyan highlight)
        let rimLight = SCNLight()
        rimLight.type = .directional
        rimLight.color = UIColor(red: 0.0, green: 0.85, blue: 0.95, alpha: 1.0)
        rimLight.intensity = 600
        let rimLightNode = SCNNode()
        rimLightNode.light = rimLight
        rimLightNode.position = SCNVector3(x: -6, y: 4, z: -6)
        rimLightNode.eulerAngles = SCNVector3(0.5, -2.4, 0)
        newScene.rootNode.addChildNode(rimLightNode)

        // Ambient Fill (Deep Navy)
        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.color = UIColor(red: 0.15, green: 0.20, blue: 0.32, alpha: 1.0)
        ambientLight.intensity = 300
        let ambientNode = SCNNode()
        ambientNode.light = ambientLight
        newScene.rootNode.addChildNode(ambientNode)

        // 3. Ground Reflection / Shadow plane
        let floorGeo = SCNFloor()
        floorGeo.reflectivity = 0.15
        floorGeo.reflectionFalloffEnd = 4.0
        let floorMat = SCNMaterial()
        floorMat.diffuse.contents = UIColor(red: 0.03, green: 0.05, blue: 0.10, alpha: 1.0)
        floorGeo.materials = [floorMat]
        let floorNode = SCNNode(geometry: floorGeo)
        floorNode.position = SCNVector3(0, -0.6, 0)
        newScene.rootNode.addChildNode(floorNode)

        // 4. Procedural Router Hardware
        let router = RouterProceduralGeometry.createRouterNode(connectionState: connectionState)
        newScene.rootNode.addChildNode(router)
        self.routerRootNode = router
        self.scene = newScene
    }

    private func animateCamera(to perspective: CameraPerspective) {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.8
        SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        cameraNode.position = perspective.cameraPosition
        cameraNode.eulerAngles = perspective.cameraEulerAngles
        // Reset interactive drag rotations smoothly
        routerRootNode?.eulerAngles = SCNVector3(0, 0, 0)
        rotationX = 0
        rotationY = 0
        SCNTransaction.commit()
    }

    private func updateConnectionState(_ state: ConnectionState) {
        routerRootNode?.removeFromParentNode()
        let updatedRouter = RouterProceduralGeometry.createRouterNode(connectionState: state)
        scene.rootNode.addChildNode(updatedRouter)
        self.routerRootNode = updatedRouter
    }
}
