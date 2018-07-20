//
//  GameARViewController.swift
//  Save the Trees!
//
//  Created by Leonardo Alves de Melo on 13/07/18.
//  Copyright © 2018 Leonardo Alves de Melo. All rights reserved.
//

import UIKit
import ARKit
import AudioToolbox

class GameARViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var informationView: UIView!
    @IBOutlet weak var informationLabel: UILabel!
    
    var savedTreesPercentage = 0
    
    var gameARManager: GameARManager!
    
    var gamePlane: ARPlaneAnchor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gameARManager = GameARManager(delegate: self)
        self.informationView.layer.cornerRadius = 10
        self.informationView.layer.masksToBounds = true
        
   
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.gameARManager.didEndTap()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if self.gamePlane != nil {
            
            if self.gameARManager.gameAdded {
                
                if self.gameARManager.gameStarted {
                    guard let location = touches.first?.location(in: sceneView) else { return }
                    
                    let hitNodes = sceneView.hitTest(location, options: nil)
                    
                    self.gameARManager.didTapIn(node: hitNodes.first?.node)
                }
                else {
                    self.startGame()
                }

            }
            else {
                self.addGame()
            }
            
            
            
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
        
        self.showInformation(information: NSLocalizedString("Move your camera until I get a plane", comment: "Move your camera until I get a plane"))
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
    
    func showInformation(information: String) {
        self.informationLabel.text = information
        
        self.hideInformation()
        
        UIView.animate(withDuration: 1.5, animations: {
            self.informationView.alpha = 0.7
        }) { (ok) in

        }

    }
    
    func hideInformation() {
        UIView.animate(withDuration: 0.5, animations: {
            self.informationView.alpha = 0.0
        }) { (ok) in
            
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
    
    func addGame() {
        self.gameARManager.putGameIn(anchor: self.gamePlane!)
        self.showInformation(information: NSLocalizedString("The Game has been added! Tap to start it.", comment: "The Game has been added! Tap to start it."))
    }
    
    func startGame() {
        self.gameARManager.startGame()
        self.hideInformation()
    }
}

extension GameARViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let anchor = anchor as? ARPlaneAnchor {
            
            
            
            if !self.gameARManager.gameAdded {
                self.gamePlane = anchor
            }
            
            DispatchQueue.main.async {
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                self.showInformation(information: NSLocalizedString("I found a plane! Tap to add the Game.", comment: "I found a plane! Tap to add the Game."))
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
