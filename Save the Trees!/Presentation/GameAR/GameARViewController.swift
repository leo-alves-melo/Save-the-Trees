//
//  GameARViewController.swift
//  Save the Trees!
//
//  Created by Leonardo Alves de Melo on 13/07/18.
//  Copyright © 2018 Leonardo Alves de Melo. All rights reserved.
//

import UIKit
import ARKit

class GameARViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(GameARViewController.handleTap(gestureRecognize:)))
        
        //self.view.addGestureRecognizer(tapGesture)
        
        
        
        
        //let scene = SCNScene(named: "art.scnassets/game.scn")!
        
        // Set the scene to the view
        //sceneView.scene = scene
        
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        self.sceneView.scene = SCNScene(named: "art.scnassets/game.scn")!
        self.sceneView.scene.rootNode.isHidden = true
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
//    @objc
//    func handleTap(gestureRecognize:UITapGestureRecognizer) {
//
//
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesBegan")
        guard let location = touches.first?.location(in: sceneView) else { return }
        
        let hitResultsPlanes: [ARHitTestResult] = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
        
        let hitNodes = sceneView.hitTest(location, options: nil)
        
        if let hitNode = hitNodes.first {
            print("node: \(hitNode.node.name)") // pyramid
            
            print("node: \(hitNode.node.parent?.name)") // tree
            
            print("node: \(hitNode.node.parent?.parent?.name)") // reference node
        }
        
        if let hit = hitResultsPlanes.first {
            
            
            
            let finalTransform = hit.worldTransform
            
            let pointTranslation = finalTransform.translation
            
//            sceneView.hitTest(location, types: .featurePoint)
            
            if let nodeHitted = sceneView.hitTest(location, options: nil).first {
                
                
                //nodeHitted.node.removeFromParentNode()

                print("node: \(nodeHitted.node.name)")
                
                print("node: \(nodeHitted.node.parent?.name)")

            }
            
//            else {
//                guard let scene = SCNScene(named: "art.scnassets/game.scn") else {
//                    //return nil
//                    return
//                }
//                let node = scene.rootNode.childNode(withName: "tree01 reference", recursively: true)!
//                node.position = SCNVector3(pointTranslation.x, pointTranslation.y, pointTranslation.z)
//                sceneView.scene.rootNode.addChildNode(node)
//            }
            
            
            
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard ARWorldTrackingConfiguration.isSupported else {
            fatalError("""
                ARKit is not available on this device. For apps that require ARKit
                for core functionality, use the `arkit` key in the key in the
                `UIRequiredDeviceCapabilities` section of the Info.plist to prevent
                the app from installing. (If the app can't be installed, this error
                can't be triggered in a production scenario.)
                In apps where AR is an additive feature, use `isSupported` to
                determine whether to show UI for launching AR experiences.
            """) // For details, see https://developer.apple.com/documentation/arkit
        }
        
        // Prevent the screen from being dimmed after a while.
        UIApplication.shared.isIdleTimerDisabled = true
        
        // Start a new session
        self.startNewSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func startNewSession() {
        
        // Create a session configuration with horizontal plane detection
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration, options: [.removeExistingAnchors, .resetTracking])
    }
}

extension GameARViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor {
            
            let planeAnchor = anchor as! ARPlaneAnchor
            
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            let planeNode = SCNNode()
            
            planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
            
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            
            let gridMaterial = SCNMaterial()
            
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            
            plane.materials = [gridMaterial]
            
            planeNode.geometry = plane
            
            node.addChildNode(planeNode)
            
            //sceneView.scene.rootNode.runAction(SCNAction.move(by: SCNVector3(x: planeAnchor.center.x, y: planeAnchor.center.y, z: planeAnchor.center.z), duration: 3))
            
//            for rootNode in self.sceneView.scene.rootNode.childNodes {
//
//                if rootNode.name != nil {
//                    rootNode.runAction(SCNAction.move(to: SCNVector3(x: planeAnchor.center.x, y: planeAnchor.center.y, z: planeAnchor.center.z), duration: 3.0))
//                }
//
//            }
            

            
            
            //self.sceneView.scene.rootNode.simdTransform = anchor.transform
//            self.sceneView.scene.rootNode.isHidden = false
            
            //self.sceneView.scene.rootNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
            
            self.sceneView.scene.rootNode.isHidden = false
            
//            guard let scene = SCNScene(named: "art.scnassets/game.scn") else {
//                //return nil
//                return
//            }
//            let node = scene.rootNode.childNode(withName: "tree01 reference", recursively: true)!
//
//            node.simdTransform = anchor.transform
//            //node.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
//            //node.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
//            sceneView.scene.rootNode.addChildNode(node)
            
        }
    }
}

extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}
