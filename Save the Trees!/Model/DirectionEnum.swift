//
//  DirectionEnum.swift
//  Save the Trees!
//
//  Created by Leonardo Alves de Melo on 19/03/18.
//  Copyright © 2018 Leonardo Alves de Melo. All rights reserved.
//

import Foundation

enum Direction: Int {
    case right = 0, left, down, up
    
    init(rawValue:Int) {
        switch rawValue {
        case 0:
            self = .right
        case 1:
            self = .left
        case 2:
            self = .down
        case 3:
            self = .up
        default:
            self = .right
        }
    }
}
