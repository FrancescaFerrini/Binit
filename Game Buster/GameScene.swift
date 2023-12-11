//
//  GameScene.swift
//  Game Buster
//
//  Created by Francesca Ferrini on 10/12/23.
//

import SpriteKit
import GameplayKit


struct PhysicsCategory{
    static let none : UInt32 = 0
    static let all : UInt32 = UInt32.max
    static let player : UInt32 = 0b1
    static let waste : UInt32 = 0b10
    
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //VARIABILI
    private var swipeRightGesture: UISwipeGestureRecognizer!
    private var swipeLeftGesture: UISwipeGestureRecognizer!
    var lifeIndexCount = 0
    //var positionAdd:CGFloat = (x: 100, y: 100)
    var player: SKSpriteNode!
    var livesArray: [SKSpriteNode]!
    var isMovingToTheRight: Bool = false
    var isMovingToTheLeft: Bool = false
    var scoreLabel: SKLabelNode!
    var fallingWasteTime : Timer!
    var possibleWaste = ["banana", "compost1", "compost2", "compost3"]
    var score: Int = 0 {
        //didSet viene chiamata automaticamente ogni volta che la variabile score viene modificata, e viene utilizzata per aggiornare dinamicamente il testo dell'etichetta del punteggio.
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    
    override func didMove(to view: SKView) {
        setupBackground()
        addSwipeGesture()
        initializeScore()
        addLives()
        addWaste()
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        var timeInterval = 0.75
        fallingWasteTime =  Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(addWaste), userInfo: nil, repeats: true)
    }
    
    //---IMPOSTIAMO BACKGROUND---
    private func setupBackground(){
        let background = SKSpriteNode(imageNamed: "back")
        background.size = CGSize(width: frame.size.width, height: frame.size.height)
        background.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        background.alpha = 0.8
        background.zPosition = -1
        let playerInitialPosition = CGPoint(x: frame.width/2, y: frame.height/7)
        setupBin(at: playerInitialPosition)
        addChild(background)
    }
    
    //---IMPOSTIAMO CESTINO---
    private func setupBin(at position: CGPoint){
        player = SKSpriteNode(imageNamed: "binbak2")
        player.setScale(0.2)
        player.anchorPoint = CGPoint(x: 0.49, y: 0.5)
        player.name = "player"
        player.position = position
        //POSIZIONE INIZIALE
        
        let xRange = SKRange(lowerLimit: 0, upperLimit: frame.width)
        let xConstraint = SKConstraint.positionX(xRange)
        player.constraints = [xConstraint]
        player.physicsBody?.affectedByGravity = false
        /*player.physicsBody? = SKPhysicsBody(texture: player.texture!, size: player.size)
         player.physicsBody?.categoryBitMask = PhysicsCategory.player
         player.physicsBody?.isDynamic = true*/
        //player.physicsBody?.collisionBitMask = wasteCategory
        
        //##############
        player.physicsBody = SKPhysicsBody(circleOfRadius: (player.size.width * 0.4) / 2)
        player.physicsBody?.isDynamic = true
        print("SONO QUIII PLAYER")
        player.physicsBody?.categoryBitMask = PhysicsCategory.player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.waste
        player.physicsBody?.collisionBitMask = PhysicsCategory.none
        //##############
        addChild(player)
    }
    
    //---FUNZIONE CHE RICHIAMA LO SWIPE---
    private func addSwipeGesture(){
        swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRightGesture.direction = .right
        view?.addGestureRecognizer(swipeRightGesture)
        
        // Riconoscitore di swipe verso sinistra
        swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeLeftGesture.direction = .left
        view?.addGestureRecognizer(swipeLeftGesture)
    }
    
    //---FUNZIONE CHE GESTISCE LO SWIPE---
    @objc private func handleSwipe(sender: UISwipeGestureRecognizer) {
        guard let player = player else { return }
        let moveAction: SKAction
        let screenWidth = self.view?.bounds.width ?? 1.0
        let thirdScreenWidth = screenWidth / 3
        switch sender.direction {
        case .right:
            if player.position.x < thirdScreenWidth * 2 {
                moveAction = SKAction.move(by: CGVector(dx: thirdScreenWidth, dy: 0), duration: 0.2)
            } else {
                moveAction = SKAction.move(by: CGVector(dx: 0, dy: 0), duration: 0.2)
            }
        case .left:
            if player.position.x > thirdScreenWidth {
                moveAction = SKAction.move(by: CGVector(dx: -thirdScreenWidth, dy: 0), duration: 0.2)
            } else {
                moveAction = SKAction.move(by: CGVector(dx: 0, dy: 0), duration: 0.2)
            }
        default:
            return
        }
        player.run(moveAction)
    }
    
    //---FUNZIONE PER IL PUNTEGGIO---
    private func initializeScore(){
        //Inizializzo il punteggio dandogli un testo iniziale e una posizione nello schermo
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: 100, y: self.frame.size.height - 85)
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontSize = 36
        scoreLabel.fontColor = UIColor.white
        scoreLabel.zPosition = 11
        score = 0
        self .addChild(scoreLabel)
    }
    
    //IMPLEMENTO LE VITE
    func addLives(){
        livesArray = [SKSpriteNode]()
            
            let screenHeight = self.frame.size.height
            let yOffsetPercentage: CGFloat = 0.1  // Puoi regolare questa percentuale come preferisci
            
            for live in 1 ... 3 {
                let liveNode = SKSpriteNode(imageNamed: "love")
                liveNode.size = CGSize(width: 100, height: 100)  // Imposta la dimensione desiderata
                let yOffset = screenHeight - (yOffsetPercentage * screenHeight) - CGFloat(live) * liveNode.size.height
                liveNode.position = CGPoint(x: self.frame.size.width - CGFloat(4 - live) * liveNode.size.width, y: yOffset)
                self.addChild(liveNode)
                livesArray.append(liveNode)
            }
        }
    
    //---FUNZIONE CHE AGGIUNGE E GESTISCE LA CADUTA DEI RIFIUTI---
    @objc func addWaste(){
        //UTILIZZO LIBERIRA GAMEPLAYKIT
        possibleWaste = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleWaste) as! [String]
        let waste = SKSpriteNode(imageNamed: possibleWaste[0])
        let screenWidth = self.view?.bounds.width ?? 1.0
        let thirdScreenWidth = screenWidth / 3
        //POSIZIONI CASUALI IN VERTICALE
        let randomColumn = Int(arc4random_uniform(3))
        let positionX = thirdScreenWidth * CGFloat(randomColumn) + thirdScreenWidth / 2
        let animationDuration: TimeInterval = 6
        var actionArray = [SKAction]()
        waste.position = CGPoint(x: positionX, y: self.frame.size.height + waste.size.height)
        waste.physicsBody = SKPhysicsBody(rectangleOf: waste.size)
        waste.physicsBody?.isDynamic = true
        waste.physicsBody?.categoryBitMask = PhysicsCategory.waste
        waste.physicsBody?.contactTestBitMask = PhysicsCategory.player
        waste.physicsBody?.collisionBitMask = PhysicsCategory.none
        waste.physicsBody?.usesPreciseCollisionDetection = true
        actionArray.append(SKAction.move(to: CGPoint(x: positionX, y: -waste.size.height), duration: TimeInterval(animationDuration)))
        actionArray.append(SKAction.removeFromParent())
        waste.run(SKAction.sequence(actionArray))
        addChild(waste)
    }
    
    //---FUNZIONE CHE GESTISCE LA COLLISIONE---
    func collisionFunc(player: SKSpriteNode, waste: SKSpriteNode){
        print("COLPITO")
        waste.removeFromParent()
        score += 1
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("SONO QUI")
        var firstBody : SKPhysicsBody
        var secondBody : SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        if(firstBody.categoryBitMask & PhysicsCategory.player != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.waste != 0){
            collisionFunc(player: firstBody.node as! SKSpriteNode, waste:
                            secondBody.node as! SKSpriteNode)
        }
    }
}

