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
    
    var savedTreesPercentage = 0
    
    var gameARManager: GameARManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gameARManager = GameARManager(delegate: self)
   
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.gameARManager.didEndTap()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard let location = touches.first?.location(in: sceneView) else { return }

        let hitNodes = sceneView.hitTest(location, options: nil)
        
        self.gameARManager.didTapIn(node: hitNodes.first?.node)

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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segue = segue.destination as? FinalizationViewController {
            segue.savedTreesPercentage = self.savedTreesPercentage
        }
    }
    
    func startNewSession() {
        
        sceneView.showsStatistics = true
        //sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        // Create a session configuration with horizontal plane detection
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration, options: [.removeExistingAnchors, .resetTracking])
    }
}

extension GameARViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let anchor = anchor as? ARPlaneAnchor {
            
            if !self.gameARManager.gameAdded {
                self.gameARManager.putGameIn(anchor: anchor)
                self.gameARManager.startGame()
            }
        }
    }
}

extension GameARViewController: GameARManagerDelegate {
    func gameDidEnd(score: Int) {
        self.savedTreesPercentage = score
        self.performSegue(withIdentifier: "Finalization", sender: nil)
    }
}
