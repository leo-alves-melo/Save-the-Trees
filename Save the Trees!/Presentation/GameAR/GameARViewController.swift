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
        
    }
    
//    @objc
//    func handleTap(gestureRecognize:UITapGestureRecognizer) {
//
//
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: sceneView) else { return }
        
        let hitResultsFeaturePoints: [ARHitTestResult] = sceneView.hitTest(location, types: .featurePoint)
        
        if let hit = hitResultsFeaturePoints.first {
            let finalTransform = hit.worldTransform
            
            let pointTranslation = finalTransform.translation
            
            sceneView.hitTest(location, types: .featurePoint)
            
            guard let scene = SCNScene(named: "art.scnassets/game.scn") else {
                //return nil
                return
            }
            let node = scene.rootNode.childNode(withName: "tree01 reference", recursively: true)!
            node.position = SCNVector3(pointTranslation.x, pointTranslation.y, pointTranslation.z)
            sceneView.scene.rootNode.addChildNode(node)
            
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
    
}

extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}
