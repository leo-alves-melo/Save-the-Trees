//
//  GameARManager.swift
//  Save the Trees!
//
//  Created by Leonardo Alves de Melo on 18/07/18.
//  Copyright © 2018 Leonardo Alves de Melo. All rights reserved.
//

import ARKit

@objc
protocol GameARManagerDelegate {
    weak var sceneView: ARSCNView! {get}
    
    func gameDidEnd(score: Int)
}


class GameARManager: NSObject {
    
    private weak var delegate: GameARManagerDelegate?
    private var cloud: SCNNode!
    private var invisiBall: SCNNode!
    private let boardWidth = 2
    private let boardHeight = 2
    private var treesBoard: GameBoard<Tree<SCNNode>?>!
    private var timerBall = Timer()
    private var timerIterate = Timer()
    private var timeToKillTree = 4
    private var timeToKillFire = 4
    private var numberOfIterations = 30
    private var treesInitiallyWithFire = 3
    var gameAdded = false
    
    
    init(delegate: GameARManagerDelegate) {
        
        super.init()
        self.delegate = delegate
        
        
        self.createCloud()
        self.createInvisiBall()
        
        self.delegate?.sceneView.scene.physicsWorld.contactDelegate = self
        
        self.timerIterate = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.iterate), userInfo: nil, repeats: true)
    
    }
    
    func putGameIn(anchor: ARPlaneAnchor) {
        
        guard let scene = SCNScene(named: "art.scnassets/game.scn") else {
            return
        }
        let node = scene.rootNode.childNode(withName: "game", recursively: true)!
        node.simdTransform = anchor.transform

        self.delegate?.sceneView.scene.rootNode.addChildNode(node)
        
        self.gameAdded = true
    }
    
    func putPlaneIn(anchor: ARPlaneAnchor, node: SCNNode) {
        
        let plane = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        let planeNode = SCNNode()

        planeNode.position = SCNVector3(x: anchor.center.x, y: 0, z: anchor.center.z)
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)

        let gridMaterial = SCNMaterial()
        gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
        plane.materials = [gridMaterial]
        planeNode.geometry = plane
        
        node.addChildNode(planeNode)
    }
    
    func startGame() {
        self.instantiateTrees()
        

    }
    
    func didTapIn(node: SCNNode?) {
        self.startRain()
        self.startAddingInvisiBallToCloud()
    }
    
    func didEndTap() {
        self.stopRain()
        self.stopAddingInvisiBallToCloud()
    }
    
    @objc private func iterate() {
        
        if !self.gameAdded {
            return
        }
        
        var treesWithoutFire:[(Int,Int)] = []

        //Check if have to kill trees
        for line in 0..<self.treesBoard.board.count {
            for column in 0..<self.treesBoard.board[0].count {
                if self.isTreeOnFire(tree: self.treesBoard.board[line][column]) {
                    self.treesBoard.board[line][column]??.timeUnderFire += 1
                    if self.treesBoard.board[line][column]??.timeUnderFire == self.timeToKillTree {
                        self.killTree(treeLine: line, treeColumn: column)
                    }
                }
                else {
                    if self.treesBoard.board[line][column] != nil {
                        treesWithoutFire.append((line, column))
                    }
                    
                }
            }
        }
        
        //Put some trees on fire
        if treesWithoutFire.count > 0 {
            let randomTree = Int(arc4random_uniform(UInt32(treesWithoutFire.count)))
            self.addFire(node: self.treesBoard.board[treesWithoutFire[randomTree].0][treesWithoutFire[randomTree].1]!!.tree)
        }
        
        if self.numberOfIterations == 0 {
            self.endGame()
        }
        
        self.numberOfIterations -= 1
        
        
    }
    
    private func killTree(treeLine: Int, treeColumn: Int) {
        
        if self.treesBoard.board[treeLine][treeColumn] != nil {
            self.removeFire(node: self.treesBoard.board[treeLine][treeColumn]!!.tree)
            
            self.treesBoard.board[treeLine][treeColumn]??.tree.childNode(withName: "leaf", recursively: true)!.isHidden = true
            
            self.treesBoard.board[treeLine][treeColumn] = nil
        }
        
        
    }

    private func isTreeOnFire(tree: Tree<SCNNode>??) -> Bool {
        
        if let tree = tree {
            if let tree = tree {
                if let particles = tree.tree.particleSystems {
                    return particles.count > 0
                }
            }
        }
        
        return false
        
    }
    
    private func endGame() {
        self.timerIterate.invalidate()
        self.delegate?.gameDidEnd(score: 100*self.treesBoard.countNumberOfElements()/(self.boardHeight*self.boardWidth))
    }
    
    private func instantiateTrees() {
        
        self.treesBoard = GameBoard(height: self.boardHeight)
        
        for line in 0..<boardHeight {
            
            for column in 0..<boardWidth {
                let tree = self.delegate?.sceneView.scene.rootNode.childNode(withName: "tree\(line)\(column)", recursively: true)!
                
                self.treesBoard.board[line].append(Tree(tree: tree!))

            }
        }
        
    }
    
    private func createCloud() {
        guard let scene = SCNScene(named: "art.scnassets/cloud.scn") else {
            return
        }
        self.cloud = scene.rootNode.childNode(withName: "cloud", recursively: true)!
        self.delegate?.sceneView.pointOfView!.addChildNode(cloud)
        
    }
    
    private func startRain() {
        let rainParticle = SCNParticleSystem(named: "RainParticle.scnp", inDirectory: nil)!
        
        self.cloud.addParticleSystem(rainParticle)
    }
    
    private func stopRain() {
        self.cloud.removeAllParticleSystems()
    }
    
    private func createInvisiBall() {
        guard let scene = SCNScene(named: "art.scnassets/invisiBall.scn") else {
            return
        }
        self.invisiBall = scene.rootNode.childNode(withName: "invisiBall", recursively: true)!
        
    }
    
    private func startAddingInvisiBallToCloud() {
        
        self.timerBall = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.addInvisiBallToCloud), userInfo: nil, repeats: true)
        
    }
    
    private func stopAddingInvisiBallToCloud() {
        self.timerBall.invalidate()
    }
    
    @objc private func addInvisiBallToCloud() {
        
        if self.invisiBall.parent != nil {
            self.invisiBall.removeFromParentNode()
            self.createInvisiBall()
        }
        
        self.cloud.addChildNode(self.invisiBall)
        
        //self.iterate()

    }
    
    private func addFire(node: SCNNode) {
        let fireParticle = SCNParticleSystem(named: "FireParticle.scnp", inDirectory: nil)!
        node.addParticleSystem(fireParticle)
    }
    
    private func removeFire(node: SCNNode) {
        node.removeAllParticleSystems()
        let nodePosition = self.getTreePosition(tree: node)
        self.treesBoard.board[nodePosition.0][nodePosition.1]??.timeUnderFire = 0
        self.treesBoard.board[nodePosition.0][nodePosition.1]??.timeUnderWater = 0
    }
    
    private func getTreePosition(tree: SCNNode) -> (Int, Int) {
        if let name = tree.name {
            let line = Int(name[name.index(name.startIndex, offsetBy: 4)..<name.index(name.startIndex, offsetBy: 5)])!
            let column = Int(name[name.index(name.startIndex, offsetBy: 5)..<name.index(name.startIndex, offsetBy: 6)])!
            return (line,column)
        }
        
        return (-1,-1)
    }
    
}

extension GameARManager: SCNPhysicsContactDelegate {
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        
        let nodePosition = self.getTreePosition(tree: contact.nodeA)
        
        if self.treesBoard.board[nodePosition.0][nodePosition.1] != nil {
            self.treesBoard.board[nodePosition.0][nodePosition.1]??.timeUnderWater += 1
            
            if self.treesBoard.board[nodePosition.0][nodePosition.1]!!.timeUnderWater == self.timeToKillFire {
                self.removeFire(node: contact.nodeA)
            }
        }
    }
}
