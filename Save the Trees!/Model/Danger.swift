//
//  Danger.swift
//  Save the Trees!
//
//  Created by Leonardo Alves de Melo on 16/03/18.
//  Copyright © 2018 Leonardo Alves de Melo. All rights reserved.
//

import Foundation

/// A game danger, it can be everything that could be harmful in a tap game
protocol Danger {
    /// Number of taps until the danger dies
    var tapsUntilDie: Int {get set}
    /// Number of iterations until the danger kill the element in its position
    var iterationsUntilKill: Int {get set}
    /// x position of the danger
    var x:Int {get set}
    /// y position of the danger
    var y:Int {get set}
    /// Number of iterations until the danger change position
    var iterationsUntilMove: Int {get set}
    /// Number of move iterations that happened until now
    var moveIterations:Int {get set}
    /// Number of kill iterations that happened until now
    var killIterations:Int {get set}
    
    /// Remove the danger when it is done
    func removeFromParent()
    
}

extension Danger {
    /// Iterate the danger
    ///
    /// - Returns: true if it is time to the Game Control do some change, which can be move or kill
    mutating func iterate() -> Bool {
        self.moveIterations+=1
        self.killIterations+=1
        
        if self.iterationsUntilKill == killIterations {
            return true
        }
        
        if self.iterationsUntilMove == moveIterations {
            
            return true
        }
        
        return false
    }
}
