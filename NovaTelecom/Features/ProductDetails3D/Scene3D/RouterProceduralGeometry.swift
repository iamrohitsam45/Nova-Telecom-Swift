import SceneKit
import SwiftUI

public final class RouterProceduralGeometry {
    public static func createRouterNode(connectionState: ConnectionState = .online) -> SCNNode {
        let rootNode = SCNNode()
        rootNode.name = "RouterRootNode"

        // 1. Chassis Body (Sleek aerodynamic bevel box)
        let bodyGeo = SCNBox(width: 4.8, height: 0.9, length: 3.2, chamferRadius: 0.25)
        let bodyMat = SCNMaterial()
        bodyMat.diffuse.contents = UIColor(red: 0.08, green: 0.10, blue: 0.15, alpha: 1.0)
        bodyMat.roughness.contents = 0.35
        bodyMat.metalness.contents = 0.65
        bodyGeo.materials = [bodyMat]

        let chassisNode = SCNNode(geometry: bodyGeo)
        chassisNode.position = SCNVector3(0, 0, 0)
        chassisNode.name = "ChassisNode"
        rootNode.addChildNode(chassisNode)

        // 2. Top Vent Grille / Accent Plate
        let ventGeo = SCNBox(width: 3.8, height: 0.05, length: 2.2, chamferRadius: 0.05)
        let ventMat = SCNMaterial()
        ventMat.diffuse.contents = UIColor(red: 0.04, green: 0.06, blue: 0.09, alpha: 1.0)
        ventMat.roughness.contents = 0.5
        ventGeo.materials = [ventMat]
        let ventNode = SCNNode(geometry: ventGeo)
        ventNode.position = SCNVector3(0, 0.46, 0)
        chassisNode.addChildNode(ventNode)

        // Center Brand Glow Ring on top plate
        let ringGeo = SCNTorus(ringRadius: 0.5, pipeRadius: 0.03)
        let ringMat = SCNMaterial()
        ringMat.diffuse.contents = UIColor(red: 0.0, green: 0.85, blue: 0.95, alpha: 1.0)
        ringMat.emission.contents = UIColor(red: 0.0, green: 0.85, blue: 0.95, alpha: 1.0)
        ringGeo.materials = [ringMat]
        let ringNode = SCNNode(geometry: ringGeo)
        ringNode.position = SCNVector3(0, 0.5, 0)
        ringNode.rotation = SCNVector4(1, 0, 0, Float.pi / 2)
        chassisNode.addChildNode(ringNode)

        // 3. Six Articulated Antennas (4 Rear, 2 Sides)
        let antennaPositions: [(x: Float, y: Float, z: Float, tiltZ: Float, tiltX: Float)] = [
            // Left & Right Sides
            (-2.45, 0.2, 0.4, 0.18, 0.0),
            (2.45, 0.2, 0.4, -0.18, 0.0),
            // Rear 4 Antennas
            (-1.8, 0.3, -1.65, 0.12, -0.15),
            (-0.6, 0.3, -1.65, 0.04, -0.18),
            (0.6, 0.3, -1.65, -0.04, -0.18),
            (1.8, 0.3, -1.65, -0.12, -0.15)
        ]

        let antennasParent = SCNNode()
        antennasParent.name = "AntennasParent"

        for (index, pos) in antennaPositions.enumerated() {
            let antennaAssembly = createSingleAntennaNode(index: index)
            antennaAssembly.position = SCNVector3(pos.x, pos.y, pos.z)
            antennaAssembly.eulerAngles = SCNVector3(pos.tiltX, 0, pos.tiltZ)
            antennasParent.addChildNode(antennaAssembly)
        }
        rootNode.addChildNode(antennasParent)

        // 4. Front Status Diagnostic LEDs
        let ledsNode = createFrontStatusLEDs(connectionState: connectionState)
        ledsNode.position = SCNVector3(0, 0.05, 1.62)
        rootNode.addChildNode(ledsNode)

        // 5. Rear Ports Array (Fiber SC/APC, 10G WAN, 4x LAN, USB, DC, WPS)
        let portsNode = createRearPortsNode()
        portsNode.position = SCNVector3(0, -0.05, -1.62)
        rootNode.addChildNode(portsNode)

        // 6. Wi-Fi Wave Torus Particles
        let wifiWavesNode = createWifiWaveEmitterNode(connectionState: connectionState)
        wifiWavesNode.position = SCNVector3(0, 1.2, 0)
        wifiWavesNode.name = "WifiWavesEmitter"
        rootNode.addChildNode(wifiWavesNode)

        return rootNode
    }

    private static func createSingleAntennaNode(index: Int) -> SCNNode {
        let parent = SCNNode()
        parent.name = "Antenna_\(index)"

        // Hinge base cylinder
        let hingeGeo = SCNCylinder(radius: 0.14, height: 0.28)
        let hingeMat = SCNMaterial()
        hingeMat.diffuse.contents = UIColor(red: 0.15, green: 0.18, blue: 0.25, alpha: 1.0)
        hingeMat.metalness.contents = 0.8
        hingeGeo.materials = [hingeMat]
        let hingeNode = SCNNode(geometry: hingeGeo)
        parent.addChildNode(hingeNode)

        // Antenna Mast (Tapered blade)
        let mastGeo = SCNBox(width: 0.18, height: 2.4, length: 0.12, chamferRadius: 0.04)
        let mastMat = SCNMaterial()
        mastMat.diffuse.contents = UIColor(red: 0.09, green: 0.11, blue: 0.17, alpha: 1.0)
        mastMat.roughness.contents = 0.4
        mastGeo.materials = [mastMat]
        let mastNode = SCNNode(geometry: mastGeo)
        mastNode.position = SCNVector3(0, 1.2, 0)
        parent.addChildNode(mastNode)

        // Top Accent Stripe
        let tipGeo = SCNBox(width: 0.2, height: 0.2, length: 0.14, chamferRadius: 0.02)
        let tipMat = SCNMaterial()
        tipMat.diffuse.contents = UIColor(red: 0.0, green: 0.85, blue: 0.95, alpha: 1.0)
        tipMat.emission.contents = UIColor(red: 0.0, green: 0.85, blue: 0.95, alpha: 0.6)
        tipGeo.materials = [tipMat]
        let tipNode = SCNNode(geometry: tipGeo)
        tipNode.position = SCNVector3(0, 2.3, 0)
        parent.addChildNode(tipNode)

        return parent
    }

    private static func createFrontStatusLEDs(connectionState: ConnectionState) -> SCNNode {
        let parent = SCNNode()
        parent.name = "FrontStatusLEDs"

        let ledSpacing: Float = 0.45
        let startX: Float = -1.35

        let ledColors: [UIColor] = {
            switch connectionState {
            case .online:
                // Cyan and green active LEDs
                return [
                    UIColor(red: 0.0, green: 0.85, blue: 0.95, alpha: 1.0), // Power
                    UIColor(red: 0.13, green: 0.77, blue: 0.45, alpha: 1.0), // Internet
                    UIColor(red: 0.0, green: 0.85, blue: 0.95, alpha: 1.0), // 2.4G
                    UIColor(red: 0.0, green: 0.85, blue: 0.95, alpha: 1.0), // 5G
                    UIColor(red: 0.58, green: 0.22, blue: 0.98, alpha: 1.0), // 6G
                    UIColor(red: 0.13, green: 0.77, blue: 0.45, alpha: 1.0), // VoIP
                    UIColor.lightGray.withAlphaComponent(0.3) // WPS idle
                ]
            case .connecting:
                // Blinking / pulsing amber
                let amber = UIColor(red: 1.0, green: 0.65, blue: 0.15, alpha: 1.0)
                return [amber, amber, amber, amber.withAlphaComponent(0.4), amber.withAlphaComponent(0.4), amber.withAlphaComponent(0.4), amber]
            case .weakSignal:
                let amber = UIColor(red: 1.0, green: 0.65, blue: 0.15, alpha: 1.0)
                let green = UIColor(red: 0.13, green: 0.77, blue: 0.45, alpha: 1.0)
                return [green, amber, green, amber, amber, green, amber.withAlphaComponent(0.4)]
            case .offline:
                // Red error indicator
                let red = UIColor(red: 0.96, green: 0.26, blue: 0.26, alpha: 1.0)
                return [red, red, UIColor.darkGray, UIColor.darkGray, UIColor.darkGray, UIColor.darkGray, UIColor.darkGray]
            }
        }()

        for i in 0..<7 {
            let ledGeo = SCNCylinder(radius: 0.04, height: 0.04)
            let ledMat = SCNMaterial()
            let c = ledColors[i]
            ledMat.diffuse.contents = c
            ledMat.emission.contents = c
            ledGeo.materials = [ledMat]

            let ledNode = SCNNode(geometry: ledGeo)
            ledNode.position = SCNVector3(startX + Float(i) * ledSpacing, 0, 0)
            ledNode.rotation = SCNVector4(1, 0, 0, Float.pi / 2)
            ledNode.name = "LED_\(i)"

            // Subtle pulsing animation on internet LED
            if i == 1 && (connectionState == .online || connectionState == .connecting) {
                let fadeOut = SCNAction.fadeOpacity(to: 0.35, duration: 0.7)
                let fadeIn = SCNAction.fadeOpacity(to: 1.0, duration: 0.7)
                let pulse = SCNAction.repeatForever(SCNAction.sequence([fadeOut, fadeIn]))
                ledNode.runAction(pulse)
            }

            parent.addChildNode(ledNode)
        }

        return parent
    }

    private static func createRearPortsNode() -> SCNNode {
        let parent = SCNNode()
        parent.name = "RearPortsNode"

        // Port 1: SC/APC Fiber Optical Port (Bright green shroud)
        let scGeo = SCNBox(width: 0.35, height: 0.35, length: 0.25, chamferRadius: 0.04)
        let scMat = SCNMaterial()
        scMat.diffuse.contents = UIColor(red: 0.1, green: 0.75, blue: 0.2, alpha: 1.0)
        scGeo.materials = [scMat]
        let scNode = SCNNode(geometry: scGeo)
        scNode.position = SCNVector3(-1.8, 0, 0)
        parent.addChildNode(scNode)

        // Port 2: 10GbE WAN Port (Gold shielded RJ-45)
        let wanGeo = SCNBox(width: 0.42, height: 0.38, length: 0.22, chamferRadius: 0.04)
        let wanMat = SCNMaterial()
        wanMat.diffuse.contents = UIColor(red: 0.85, green: 0.7, blue: 0.2, alpha: 1.0)
        wanMat.metalness.contents = 0.9
        wanGeo.materials = [wanMat]
        let wanNode = SCNNode(geometry: wanGeo)
        wanNode.position = SCNVector3(-1.2, 0, 0)
        parent.addChildNode(wanNode)

        // Ports 3-6: 4x 2.5GbE LAN Ports (Metal RJ-45)
        let lanSpacing: Float = 0.46
        let lanStart: Float = -0.5
        for j in 0..<4 {
            let lanGeo = SCNBox(width: 0.38, height: 0.36, length: 0.2, chamferRadius: 0.04)
            let lanMat = SCNMaterial()
            lanMat.diffuse.contents = UIColor(red: 0.25, green: 0.3, blue: 0.4, alpha: 1.0)
            lanMat.metalness.contents = 0.7
            lanGeo.materials = [lanMat]
            let lanNode = SCNNode(geometry: lanGeo)
            lanNode.position = SCNVector3(lanStart + Float(j) * lanSpacing, 0, 0)
            parent.addChildNode(lanNode)
        }

        // Port 7: USB 3.2 Gen 2 Port (Blue slot)
        let usbGeo = SCNBox(width: 0.36, height: 0.18, length: 0.18, chamferRadius: 0.02)
        let usbMat = SCNMaterial()
        usbMat.diffuse.contents = UIColor(red: 0.1, green: 0.4, blue: 0.9, alpha: 1.0)
        usbGeo.materials = [usbMat]
        let usbNode = SCNNode(geometry: usbGeo)
        usbNode.position = SCNVector3(1.35, 0, 0)
        parent.addChildNode(usbNode)

        // Port 8: WPS Button (Cyan tactile button)
        let wpsGeo = SCNCylinder(radius: 0.1, height: 0.08)
        let wpsMat = SCNMaterial()
        wpsMat.diffuse.contents = UIColor(red: 0.0, green: 0.85, blue: 0.95, alpha: 1.0)
        wpsGeo.materials = [wpsMat]
        let wpsNode = SCNNode(geometry: wpsGeo)
        wpsNode.position = SCNVector3(1.7, 0, 0)
        wpsNode.rotation = SCNVector4(1, 0, 0, Float.pi / 2)
        parent.addChildNode(wpsNode)

        // Port 9: 12V DC Power Jack (Black barrel receptacle)
        let dcGeo = SCNCylinder(radius: 0.14, height: 0.1)
        let dcMat = SCNMaterial()
        dcMat.diffuse.contents = UIColor.black
        dcGeo.materials = [dcMat]
        let dcNode = SCNNode(geometry: dcGeo)
        dcNode.position = SCNVector3(2.05, 0, 0)
        dcNode.rotation = SCNVector4(1, 0, 0, Float.pi / 2)
        parent.addChildNode(dcNode)

        return parent
    }

    private static func createWifiWaveEmitterNode(connectionState: ConnectionState) -> SCNNode {
        let parent = SCNNode()
        guard connectionState == .online else { return parent }

        for r in 1...3 {
            let ring = SCNTorus(ringRadius: CGFloat(0.8 + Float(r) * 0.7), pipeRadius: 0.02)
            let mat = SCNMaterial()
            let c = UIColor(red: 0.0, green: 0.85, blue: 0.95, alpha: 0.45 - CGFloat(r) * 0.12)
            mat.diffuse.contents = c
            mat.emission.contents = c
            ring.materials = [mat]

            let node = SCNNode(geometry: ring)
            node.position = SCNVector3(0, Float(r) * 0.4, 0)

            let scaleUp = SCNAction.scale(to: 1.35, duration: 2.2)
            let fadeOut = SCNAction.fadeOpacity(to: 0.1, duration: 2.2)
            let group = SCNAction.group([scaleUp, fadeOut])
            let reset = SCNAction.group([SCNAction.scale(to: 1.0, duration: 0), SCNAction.fadeOpacity(to: 0.8, duration: 0)])
            let sequence = SCNAction.sequence([group, reset])
            node.runAction(SCNAction.repeatForever(sequence))

            parent.addChildNode(node)
        }

        return parent
    }
}
