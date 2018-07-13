//
//  GameBoard.swift
//  Save the Trees!
//
//  Created by Leonardo Alves de Melo on 23/04/18.
//  Copyright © 2018 Leonardo Alves de Melo. All rights reserved.
//

import Foundation

/// A game board that accepts generics type of elements
class GameBoard<T> {
    
    /// The game board
    var board:[[T?]] = []
    
    init(height: Int) {
        for _ in 0..<height {
            self.board.append([])
        }
    }
    
    /// Removes the element of position
    ///
    /// - Parameters:
    ///   - x: x position
    ///   - y: y position
    func removeAt(x:Int, y:Int) {
        self.board[y][x] = nil
    }
    
    /// Count the number of valid elements in the board
    ///
    /// - Returns: The number of elements in the board
    func countNumberOfElements() -> Int {
        var numberOfElements = 0
        
        for line in self.board {
            for element in line {
                if let _ = element {
                    numberOfElements += 1
                }
            }
        }
        
        return numberOfElements
    }
}
