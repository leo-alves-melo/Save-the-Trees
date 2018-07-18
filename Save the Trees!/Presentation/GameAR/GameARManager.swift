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

class GameARManager {
    
    private weak var delegate: GameARManagerDelegate?
    private var cloud: SCNNode!
    private var invisiBall: SCNNode!
    private let boardWidth = 8
    private let boardHeight = 8
    private var treesBoard: GameBoard<SCNNode?>!
    
    init(delegate: GameARManagerDelegate) {
        self.delegate = delegate
        
        self.instantiateTrees()
        self.createCloud()
    
    }
    
    func putGameIn(anchor: ARPlaneAnchor) {
        
        guard let scene = SCNScene(named: "art.scnassets/game.scn") else {
            return
        }
        let node = scene.rootNode.childNode(withName: "game", recursively: true)!
        node.simdTransform = anchor.transform

        self.delegate?.sceneView.scene.rootNode.addChildNode(node)
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
        
    }
    
    func didTapIn(node: SCNNode?) {
        self.startRain()
    }
    
    func didEndTap() {
        self.stopRain()
    }
    
    private func instantiateTrees() {
        
        self.treesBoard = GameBoard(height: self.boardHeight)
        
        for line in 1...boardHeight {
            
            for column in 0..<boardWidth {
                //let tree = self.delegate?.sceneView.scene.rootNode.childNode(withName: "tree\(line)\(column)", recursively: true)!
                
                //self.treesBoard.board[line-1].append(tree)
            }
        }
        
    }
    
    private func createCloud() {
        guard let scene = SCNScene(named: "art.scnassets/cloud.scn") else {
            //return nil
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
        
        cloud.addChildNode(ball)
    }
    
    private func addFire(node: SCNNode) {
        let fireParticle = SCNParticleSystem(named: "FireParticle.scnp", inDirectory: nil)!
        
        node.addParticleSystem(fireParticle)
    }
    
}
