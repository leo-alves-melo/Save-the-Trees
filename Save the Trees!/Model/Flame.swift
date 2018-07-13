//
//  Flame.swift
//  Save the Trees!
//
//  Created by Leonardo Alves de Melo on 19/03/18.
//  Copyright © 2018 Leonardo Alves de Melo. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class Flame: SKSpriteNode, Danger {

    var iterationsUntilKill: Int
    
    var x: Int
    
    var y: Int
    
    var iterationsUntilMove: Int
    
    var moveIterations: Int = 0
    
    var killIterations: Int = 0

    
    var tapsUntilDie: Int {
        didSet {
            self.alpha = CGFloat(tapsUntilDie) / 2.0
        }
    }
    
    init(imageNamed: String, x:Int, y:Int) {
        
        let texture = SKTexture(imageNamed: imageNamed)
        
        self.iterationsUntilMove = 1
        self.iterationsUntilKill = 2
        self.tapsUntilDie = 2
        
        
        self.x = x
        self.y = y
        
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        self.zPosition = 1
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
