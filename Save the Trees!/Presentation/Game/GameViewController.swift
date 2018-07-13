//
//  GameViewController.swift
//  Save the Trees!
//
//  Created by Leonardo Alves de Melo on 15/03/18.
//  Copyright © 2018 Leonardo Alves de Melo. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    var savedTreesPercentage: Int? = nil
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene(size: view.bounds.size)
        scene.viewController = self
        let skView = view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segue = segue.destination as? FinalizationViewController {
            segue.savedTreesPercentage = self.savedTreesPercentage!
        }
    }
}
