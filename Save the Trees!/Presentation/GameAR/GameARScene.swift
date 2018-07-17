//
//  GameARScene.swift
//  Save the Trees!
//
//  Created by Leonardo Alves de Melo on 13/07/18.
//  Copyright © 2018 Leonardo Alves de Melo. All rights reserved.
//

import SceneKit

class GameARScene: SCNView {
    
    var viewController: GameARViewController!
    
    let boardWidth = 8
    let boardHeight = 8
    
    let clockRadius = CGFloat(50)
    
    var treesBoard: GameBoard<SCNNode?>!
    var clock: SCNNode!
    var clockHand: SCNNode!
    
    var dangerList: [Danger] = []
    
    var repeatedActionsTimer:Timer!
    
    //var countdownLabel:SKLabelNode!
    
    //var background:SKSpriteNode!
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        print("bananana")
    }
    
    func applyTouch() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
