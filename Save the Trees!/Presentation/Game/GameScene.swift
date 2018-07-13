//
//  GameScene.swift
//  Save the Trees!
//
//  Created by Leonardo Alves de Melo on 15/03/18.
//  Copyright © 2018 Leonardo Alves de Melo. All rights reserved.
//

import SpriteKit

public class GameScene: SKScene {
    
    var viewController: GameViewController!
    
    let boardWidth = 8
    let boardHeight = 8
    
    let clockRadius = CGFloat(50)
    
    var treesBoard: GameBoard<SKSpriteNode?>!
    var clock: SKShapeNode!
    var clockHand: SKShapeNode!
    
    var dangerList: [Danger] = []
    
    var repeatedActionsTimer:Timer!
    
    var countdownLabel:SKLabelNode!
    
    var background:SKSpriteNode!
    
    override public func didMove(to view: SKView) {
        
        self.instantiateTrees()
        self.instantiateClock()
        self.instantiateClockHand()
        self.createBackgroundTexture()
        self.createDangers()
        self.instantiateCountdownLabel()
        self.instantiateRepeatedActions()
        
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let touchedNode = self.nodes(at: touchLocation)
        
        if let node = touchedNode.first {
            if var danger = node as? Danger {
                danger.tapsUntilDie-=1
                
                
                if danger.tapsUntilDie == 0 {
                    self.kill(danger: danger)
                }
            }
            
            
        }
        else {
        }
        
    }
    
    func createBackgroundTexture() {
        
        let squareWidth = (self.size.width/8)
        for yCoordinate in 0...(Int(self.size.height/squareWidth) + 1) {
            for xCoordinate in 0...Int(self.size.width/squareWidth) {
                let ground = SKSpriteNode(imageNamed: "backgroundTexture-4")
                ground.position = CGPoint(x: CGFloat(xCoordinate)*squareWidth, y: CGFloat(yCoordinate)*squareWidth)
                ground.size = CGSize(width: squareWidth + 0.1, height: squareWidth + 0.1)
                ground.zPosition = -1
                addChild(ground)
            }
        }
    }
    
    func kill(danger: Danger) {
        danger.removeFromParent()
        dangerList = dangerList.filter({ (dangerFound) -> Bool in
            if dangerFound.x == danger.x && dangerFound.y == danger.y {
                return false
            }
            
            return true
        })
        
        if let tree = self.treesBoard.board[danger.y][danger.x] {
            let colorize = SKAction.colorize(with: SKColor.red, colorBlendFactor: 0, duration: 0.0)
            tree?.run(colorize)
            
        }
        
    }
    
    func instantiateRepeatedActions() {
        self.repeatedActionsTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.iterateAllDangers), userInfo: nil, repeats: true)
    }
    
    func createDangers() {
        
        var treesPosition:[(Int,Int)] = []
        
        for line in 0..<self.treesBoard.board.count {
            for column in 0..<self.treesBoard.board.count {
                if let _ = self.treesBoard.board[line][column] {
                    treesPosition.append((line, column))
                }
            }
        }
        
        if treesPosition.count > 8 {
            for _ in 0..<5 {
                let position = treesPosition.remove(at: Int(arc4random_uniform(UInt32(treesPosition.count))))
                self.createFlame(x: position.1, y: position.0)
            }
            for _ in 0..<3 {
                let position = treesPosition.remove(at: Int(arc4random_uniform(UInt32(treesPosition.count))))
                self.createChainSaw(x: position.1, y: position.0)
            }
        }
        else {
            if treesPosition.count > 0 {
                let position = treesPosition.remove(at: Int(arc4random_uniform(UInt32(treesPosition.count))))
                self.createFlame(x: position.1, y: position.0)
            }
        }
        
    }
    
    @objc func iterateAllDangers() {
        
        for var danger in self.dangerList {
            if danger.iterate() {
                
                
                if danger.iterationsUntilMove == danger.moveIterations {
                    var direction = Direction(rawValue: Int(arc4random_uniform(4)))
                    var trys = 16
                    danger.moveIterations = 0
                    
                    while !self.move(danger: danger, direction: direction) && trys > 0 {
                        direction = Direction(rawValue: Int(arc4random_uniform(4)))
                        trys-=1
                    }
                }
                
                if let tree = self.treesBoard.board[danger.y][danger.x]  {
                    if danger is Flame {
                        let colorize = SKAction.colorize(with: SKColor.red, colorBlendFactor: CGFloat(CGFloat(2 + danger.killIterations)/CGFloat(danger.iterationsUntilKill)), duration: 0.0)
                        tree?.run(colorize)
                    }
                }
                
                
                if danger.iterationsUntilKill == danger.killIterations {
                    if let tree = self.treesBoard.board[danger.y][danger.x] {
                        
                        if danger is Chainsaw {
                            tree?.texture = SKTexture(imageNamed: "cuttedTree")
                        }
                        if danger is Flame {
                            tree?.texture = SKTexture(imageNamed: "firedTree")
                            
                        }
                        
                        self.treesBoard.removeAt(x: danger.x, y: danger.y)
                        
                        self.kill(danger: danger)
                    }
                }
                
                
            }
        }
        
        if dangerList.count == 0 {
            self.createDangers()
        }
    }
    
    func move(danger: Danger, direction: Direction) -> Bool {
        switch direction {
        case .down:
            if danger.y + 1 != self.boardHeight && self.treesBoard.board[danger.y + 1][danger.x] != nil {
                if self.dangerList.filter({ (dangerElement) -> Bool in
                    return dangerElement.x == danger.x && dangerElement.y == danger.y + 1
                }).count == 0 {
                    self.duplicate(danger: danger, newX: danger.x, newY: danger.y + 1)
                    return true
                }
            }
        case .right:
            if danger.x + 1 != self.boardWidth && self.treesBoard.board[danger.y][danger.x + 1] != nil {
                if self.dangerList.filter({ (dangerElement) -> Bool in
                    return dangerElement.x == danger.x + 1 && dangerElement.y == danger.y
                }).count == 0 {
                    self.duplicate(danger: danger, newX: danger.x + 1, newY: danger.y)
                    return true
                }
            }
        case .left:
            if danger.x != 0 && self.treesBoard.board[danger.y][danger.x - 1] != nil {
                if self.dangerList.filter({ (dangerElement) -> Bool in
                    return dangerElement.x == danger.x - 1 && dangerElement.y == danger.y
                }).count == 0 {
                    self.duplicate(danger: danger, newX: danger.x - 1, newY: danger.y)
                    return true
                }
            }
        case .up:
            if danger.y != 0 && self.treesBoard.board[danger.y - 1][danger.x] != nil {
                if self.dangerList.filter({ (dangerElement) -> Bool in
                    return dangerElement.x == danger.x && dangerElement.y == danger.y - 1
                }).count == 0 {
                    self.duplicate(danger: danger, newX: danger.x, newY: danger.y - 1)
                    return true
                }
            }
        }
        
        return false
    }
    
    func duplicate(danger: Danger, newX:Int, newY:Int) {
        
        if danger is Flame {
            self.createFlame(x: newX, y: newY)
        }
        else if danger is Chainsaw {
            self.createChainSaw(x: newX, y: newY)
        }
    }
    
    func createFlame(x:Int, y:Int) {
        let flame1 = SKTexture(imageNamed: "flame 1")
        let flame2 = SKTexture(imageNamed: "flame 2")
        let flame3 = SKTexture(imageNamed: "flame 3")
        let flame4 = SKTexture(imageNamed: "flame 4")
        let flame5 = SKTexture(imageNamed: "flame 5")
        
        let flamesList = [flame1, flame2, flame3, flame4, flame5]
        
        let flame = Flame(imageNamed: "flame 1", x:x, y:y)
        let flamesAnimation = SKAction.animate(with: flamesList, timePerFrame: 0.2)
        flame.run(SKAction.repeatForever(flamesAnimation))
        
        flame.position = CGPoint(x: size.width/CGFloat(boardWidth) * CGFloat(x) + size.width/(CGFloat(boardWidth) * CGFloat(2)), y: size.width/CGFloat(boardHeight) * CGFloat(y+1) + size.width/(CGFloat(boardHeight) * CGFloat(2)))
        
        flame.size = CGSize(width: size.width/CGFloat(boardWidth), height: size.width/CGFloat(boardWidth))
        
        self.dangerList.append(flame)
        
        addChild(flame)
        
    }
    
    func createChainSaw(x:Int, y:Int) {
        
        let chainsaw = Chainsaw(imageNamed: "chainsaw 1", x: x, y: y)
        
        chainsaw.position = CGPoint(x: size.width/CGFloat(boardWidth) * CGFloat(x) + size.width/(CGFloat(boardWidth) * CGFloat(2)), y: size.width/CGFloat(boardHeight) * CGFloat(y+1) + size.width/(CGFloat(boardHeight) * CGFloat(2)))
        
        chainsaw.run(SKAction.repeatForever(SKAction.sequence([SKAction.rotate(byAngle: -.pi/2, duration: 1), SKAction.rotate(byAngle: .pi/2, duration: 1)])))
        
        chainsaw.size = CGSize(width: size.width/CGFloat(boardWidth), height: size.width/CGFloat(boardWidth))
        
        self.dangerList.append(chainsaw)
        
        addChild(chainsaw)
    }
    
    func endGame() {
        
        self.repeatedActionsTimer.invalidate()
        
        let move = SKAction.move(to: CGPoint(x: 70, y: self.clock.position.y), duration: 1)
        let labelMove = SKAction.move(to: CGPoint(x: 70, y: self.countdownLabel.position.y), duration: 1)
        let backgroundMove = SKAction.move(to: CGPoint(x: 70, y: self.background.position.y), duration: 1)
        self.clock.run(move)
        self.countdownLabel.run(labelMove)
        self.background.run(backgroundMove)
        self.clockHand.run(move) {
            self.instantiateTimesUpsLabel()
            self.run(SKAction.wait(forDuration: 3.0), completion: {
                self.viewController.performSegue(withIdentifier: "Finalization", sender: nil)
            })
            
            
        }
        
        self.calculateSavedTreesPercentage()
    }
    
    func calculateSavedTreesPercentage() {
        
        let savedTrees = self.treesBoard.countNumberOfElements()
        
        self.viewController.savedTreesPercentage = savedTrees*100/(boardWidth*boardHeight)
    }
    
    func instantiateTimesUpsLabel() {
        let timesUpLabel = SKLabelNode(fontNamed: FONT_BOLD)
        timesUpLabel.text = NSLocalizedString("Time is Up!", comment: "Time is Up!")
        timesUpLabel.fontSize = 40
        timesUpLabel.fontColor = SKColor.white
        timesUpLabel.position = CGPoint(x: size.width/2 + 50, y: size.height - 120)
        
        addChild(timesUpLabel)
    }
    
    func instantiateCountdownLabel() {
        self.countdownLabel = SKLabelNode(fontNamed: FONT_BOLD)
        self.countdownLabel.text = "60"
        self.countdownLabel.fontSize = 25
        self.countdownLabel.fontColor = SKColor.white
        self.countdownLabel.position = CGPoint(x: size.width/2, y: size.height - 150)
        self.countdownLabel.fontColor = SKColor.white
        
        self.background = SKSpriteNode(color: UIColor(red: 66/250.0, green: 148/250.0, blue: 33/250.0, alpha: 1.0), size: CGSize(width: self.clockHand.frame.size.width, height: CGFloat(self.countdownLabel.frame.size.height + 10)))
        background.position = CGPoint(x: self.countdownLabel.position.x, y: self.countdownLabel.position.y + 10)
        
        var countdown = 60
        
        let animate = SKAction.run {
            
            if countdown > 0 {
                countdown -= 1
            }
            
            self.countdownLabel.text = "\(countdown)"
        }
        
        let wait = SKAction.wait(forDuration:1)
        let action = SKAction.sequence([wait, animate])
        
        run(SKAction.repeat(action,count:60), completion: {})
        
        addChild(background)
        addChild(self.countdownLabel)
        
    }
    
    func instantiateClock() {
        self.clock = SKShapeNode(circleOfRadius: clockRadius)
        self.clock.position = CGPoint(x: size.width/2, y: size.height - 70)
        self.clock.strokeColor = UIColor(red: 66/250.0, green: 148/250.0, blue: 33/250.0, alpha: 1.0)
        self.clock.lineWidth = 5
        self.clock.fillColor = UIColor.white
        
        addChild(self.clock)
        
        
    }
    
    func instantiateClockHand() {
        
        self.clockHand = SKShapeNode(circleOfRadius: clockRadius)
        self.clockHand.lineWidth = 5
        self.clockHand.position = self.clock.position
        self.clockHand.fillColor = UIColor(red: 40/250.0, green: 165/250.0, blue: 40/250.0, alpha: 1.0)
        self.clockHand.strokeColor = UIColor(red: 66/250.0, green: 148/250.0, blue: 33/250.0, alpha: 1.0)
        
        guard let path = clockHand.path else {
            return
        }
        
        let radius = path.boundingBox.width/2
        let timeInterval = 1.0
        let incr = 1 / CGFloat(60)
        var percent = CGFloat(1.0)
        
        let steps = 60
        
        let animate = SKAction.run {
            percent -= incr
            
            self.clockHand.path = self.circle(radius: radius, percent:percent)
            
            if percent < 0.5 {
                
                if percent < 0.25 {
                    self.clockHand.fillColor = SKColor.red
                }
                else {
                    self.clockHand.fillColor = SKColor.yellow
                }
                
            }
        }
        
        let wait = SKAction.wait(forDuration:timeInterval)
        let action = SKAction.sequence([wait, animate])
        
        run(SKAction.repeat(action,count:steps-1)) {
            self.run(SKAction.wait(forDuration:timeInterval)) {
                self.endGame()
            }
        }
        addChild(self.clockHand)
    }
    
    func circle(radius:CGFloat, percent:CGFloat) -> CGPath {
        let start:CGFloat = CGFloat.pi/2
        let end = CGFloat.pi * 2 * percent + CGFloat.pi/2
        let center = CGPoint.zero
        let bezierPath = UIBezierPath()
        bezierPath.move(to:center)
        bezierPath.addArc(withCenter:center, radius: radius, startAngle: start, endAngle: end, clockwise: true)
        bezierPath.addLine(to:center)
        return bezierPath.cgPath
    }
    
    func instantiateTrees() {
        
        self.treesBoard = GameBoard(height: boardHeight)
        
        for line in 1...boardHeight {
            
            for column in 0..<boardWidth {
                let tree = SKSpriteNode(imageNamed: "tree")
                tree.size = CGSize(width: size.width/CGFloat(boardWidth), height: size.width/CGFloat(boardWidth))
                tree.position = CGPoint(x: size.width/CGFloat(boardWidth) * CGFloat(column) + size.width/(CGFloat(boardWidth) * CGFloat(2)), y: size.width/CGFloat(boardHeight) * CGFloat(line) + size.width/(CGFloat(boardHeight) * CGFloat(2)))
                
                self.treesBoard.board[line-1].append(tree)
                
                addChild(tree)
            }
        }
        
    }
}
