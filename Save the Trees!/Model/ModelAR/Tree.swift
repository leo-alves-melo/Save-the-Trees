//
//  TreeAR.swift
//  Save the Trees!
//
//  Created by Leonardo Alves de Melo on 19/07/18.
//  Copyright © 2018 Leonardo Alves de Melo. All rights reserved.
//

import Foundation

class Tree<T> {
    var timeUnderFire = 0
    var timeUnderWater = 0
    var tree: T
    
    init(tree: T) {
        self.tree = tree
    }
}
