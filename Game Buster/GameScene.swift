//
//  GameScene.swift
//  Game Buster
//
//  Created by Francesca Ferrini on 10/12/23.
//

import SpriteKit
import GameplayKit
import AVFoundation

struct PhysicsCategory{
    static let none : UInt32 = 0
    static let all : UInt32 = UInt32.max
    static let player : UInt32 = 0b1
    static let waste : UInt32 = 0b10
    
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //VARIABILI
    let generator = UIImpactFeedbackGenerator(style: .medium)
    var currentBin: String = "bianco"
    var currentWaste: String = "paper1"
    private var swipeRightGesture: UISwipeGestureRecognizer!
    private var swipeLeftGesture: UISwipeGestureRecognizer!
    var changePlayerAssetTimer: Timer?
    var lifeIndexCount = 0
    //var positionAdd:CGFloat = (x: 100, y: 100)
    var player: SKSpriteNode!
    var livesArray: [SKSpriteNode]!
    var pauseButton: SKSpriteNode = SKSpriteNode(imageNamed: "pause")
    var containerNode = SKNode()
    
    private var screenWidth: CGFloat { UIScreen.main.bounds.size.width }
    private var screenHeight: CGFloat { UIScreen.main.bounds.size.height }
    var isMovingToTheRight: Bool = false
    var isMovingToTheLeft: Bool = false
    var scoreLabel: SKLabelNode!
    var fallingWasteTime : Timer!
    var baseAnimationDuration: TimeInterval = 10.0
    var animationDurationIncrement: TimeInterval = 1.0
    var initialTimeInterval: TimeInterval = 2.6
    var timeIntervalDecrease: TimeInterval = 0.2
    var possibleWaste = ["paper1", "paper2", "plastic1", "plastic2", "indifferenziato1","indifferenziato2"]
    var possibleBin = ["bianco", "giallo", "marrone"]
    var increaseSpeedTimer: Timer?
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
        addLives(lives: 3)
        //addPause()
        addWaste()
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        fallingWasteTime =  Timer.scheduledTimer(timeInterval: initialTimeInterval, target: self, selector: #selector(addWaste), userInfo: nil, repeats: true)
        changePlayerAssetTimer = Timer.scheduledTimer(timeInterval: 15.0, target: self, selector: #selector(changePlayerAsset), userInfo: nil, repeats: true)
        increaseSpeedTimer = Timer.scheduledTimer(timeInterval: 15.0, target: self, selector: #selector(increaseAnimationSpeed), userInfo: nil, repeats: true)
        
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
        //playSound(sound: "NuovoBacgroundLoop", type: "mp3")
    }

    
    //---IMPOSTIAMO CESTINO---
    private func setupBin(at position: CGPoint){
        player = SKSpriteNode(imageNamed: "bianco")
        player.setScale(0.2)
        player.anchorPoint = CGPoint(x: 0.49, y: 0.5)
        player.name = "player"
        player.position = position
        //POSIZIONE INIZIALE
        
        let xRange = SKRange(lowerLimit: 0, upperLimit: frame.width)
        let xConstraint = SKConstraint.positionX(xRange)
        player.constraints = [xConstraint]
        player.physicsBody?.affectedByGravity = false
        
        //##############
        player.physicsBody = SKPhysicsBody(circleOfRadius: (player.size.width * 0.4) / 2)
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = PhysicsCategory.player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.waste
        player.physicsBody?.collisionBitMask = PhysicsCategory.none
      
        addChild(player)
    }
    
    @objc private func increaseAnimationSpeed() {
        if baseAnimationDuration > 2 {
            baseAnimationDuration -= animationDurationIncrement
        }
        else{
            baseAnimationDuration = 2
        }
        if initialTimeInterval > 0.2 {
            //fallingWasteTime.invalidate()  // Invalida il timer corrente
            initialTimeInterval -= timeIntervalDecrease
            print("***TEMPO CADUTA\(initialTimeInterval)")
        }
        else{
            initialTimeInterval = 0.2
        }
        
       
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
        scoreLabel.position = CGPoint(x: 97, y: self.frame.size.height - 100)
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontSize = 36
        scoreLabel.fontColor = UIColor.white
        scoreLabel.zPosition = 11
        score = 0
        self .addChild(scoreLabel)
    }
    
    //FUNZIONE PER IL CAMBIAMENTO DELL'ASSET
    @objc func changePlayerAsset() {
        let binOptions = ["bianco", "giallo", "marrone"].randomElement() ?? "bianco"
        currentBin = binOptions
        player.texture = SKTexture(imageNamed: binOptions)
        
    }
    
    //IMPLEMENTO LE VITE
    func addLives(lives: Int){
        livesArray = [SKSpriteNode]()
        for i in 1...lives{
            let live = SKSpriteNode(imageNamed: "love")
            live.setScale(0.3)
            live.position = CGPoint(x: size.width * 0.45 - CGFloat(i) * 50 + 17.0, y: scoreLabel.position.y - 60)
            live.name = "live"
            live.zPosition = 10
            livesArray.append(live)
            addChild(live)
        }
    }
    
    //CREAZIONE TASTO PAUSA
   /* func addPause(){
        pauseButton.name = "pause"
        pauseButton.setScale(0.5)
        pauseButton.zPosition = 10
        pauseButton.position = CGPoint(x: 350, y: self.frame.size.height - 2)
        pauseButton.isUserInteractionEnabled = true
        
        addChild(pauseButton)
    }
    
    //IMPLEMENTO IL PANNELLO DELLA PAUSA
    func createPanel(){
        
        let panel = SKSpriteNode(imageNamed: "rectangle")
        panel.name = "panel"
        panel.zPosition = 60.0
        panel.setScale(0.7)
        panel.position = CGPoint(x: 200, y: self.frame.size.height - 400)
        addChild(panel)
        
        let play = SKSpriteNode(imageNamed: "play")
        play.zPosition = 70.0
        play.name = "play"
        play.setScale(0.3)
        play.position = CGPoint(x: -panel.frame.width/2.0 + play.frame.width*1.8, y:0.0)
        panel.addChild(play)
        
        let quit = SKSpriteNode(imageNamed: "arrow")
        quit.zPosition = 70.0
        quit.name = "arrow"
        quit.setScale(0.3)
        quit.position = CGPoint(x: panel.frame.width/2.0 - quit.frame.width*1.8, y:0.0)
        panel.addChild(quit)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)
        
        if touchedNode.name == "pause" {
            if !isPaused {
                createPanel()
                isPaused = true
            }
        } else if touchedNode.name == "arrow" {
            let scene = MainMenu()
            scene.size = CGSize(width: screenWidth, height: screenHeight)
            scene.scaleMode = .fill
            view!.presentScene(scene, transition: .doorsOpenVertical(withDuration: 0.3))
            changePlayerAssetTimer?.invalidate()
            changePlayerAssetTimer = nil
        } else if touchedNode.name == "play" {
            isPaused = false
            for child in children {
                if child.name == "panel" {
                    child.removeFromParent()
                }
            }
        }
    }*/
    
    //---FUNZIONE CHE AGGIUNGE E GESTISCE LA CADUTA DEI RIFIUTI---
    @objc func addWaste(){
        //UTILIZZO LIBERIRA GAMEPLAYKIT
        possibleWaste = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleWaste) as! [String]
        currentWaste = possibleWaste[0]
        let waste = SKSpriteNode(imageNamed: currentWaste)
        let screenWidth = self.view?.bounds.width ?? 1.0
        let thirdScreenWidth = screenWidth / 3
        //POSIZIONI CASUALI IN VERTICALE
        let randomColumn = Int(arc4random_uniform(3))
        let positionX = thirdScreenWidth * CGFloat(randomColumn) + thirdScreenWidth / 2
        waste.position = CGPoint(x: positionX, y: self.frame.size.height + waste.size.height)
        waste.physicsBody = SKPhysicsBody(rectangleOf: waste.size)
        waste.physicsBody?.isDynamic = true
        waste.physicsBody?.categoryBitMask = PhysicsCategory.waste
        waste.physicsBody?.contactTestBitMask = PhysicsCategory.player
        waste.physicsBody?.collisionBitMask = PhysicsCategory.none
        waste.physicsBody?.usesPreciseCollisionDetection = true
        
        
        waste.name = currentWaste
        waste.userData = NSMutableDictionary()
        waste.userData?.setValue(currentWaste, forKey: "wasteType")
        
        var animationDuration: TimeInterval = baseAnimationDuration
        print("###TEMPO\(animationDuration)")
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: positionX, y: -waste.size.height), duration: TimeInterval(animationDuration)))
        let wasteType = waste.userData?.value(forKey: "wasteType") as? String
        let wasteOutOfScreenAction = SKAction.run { [self] in
         // Verifica se la spazzatura è uscita dallo schermo
            if waste.position.y < 0 {
                if let wasteType = waste.userData?.value(forKey: "wasteType") as? String {
                    if currentBin == "bianco" && wasteType.hasPrefix("paper") {
                        self.notCollisionFunc(waste: waste)
                        print("PERSO")
                    } else if currentBin == "giallo" && wasteType.hasPrefix("plastic") {
                        self.notCollisionFunc(waste: waste)
                        //print("PERSO")
                    } else if currentBin == "marrone" && wasteType.hasPrefix("indifferenziato") {
                        self.notCollisionFunc(waste: waste)
                        //print("PERSO")
                    } else {
                        //print("FUORI OK")
                    }
                }
            }

         }
        actionArray.append(wasteOutOfScreenAction)
        actionArray.append(SKAction.removeFromParent())
        waste.run(SKAction.sequence(actionArray))
        addChild(waste)
    }
    
    //---FUNZIONE CHE GESTISCE LA COLLISIONE---
    func collisionFunc(player: SKSpriteNode, waste: SKSpriteNode){
        //print("COLPITO")
        generator.impactOccurred()
        waste.removeFromParent()
        score += 1
    }
    func notCollisionFunc(waste: SKSpriteNode){
        //print("NON COLPITO")
        waste.removeFromParent()
        if let live = livesArray.last{
            live.removeFromParent()
            livesArray.removeLast()
            
            if livesArray.isEmpty{
                gameOver()
            }
        }
        
    }
    
    
    
    //FUNZIONE CHE GESTISCE IL GAMEOVER
    func gameOver(){
        //print("Game over!")
        ScoreGenerator.sharedInstance.setTopScore(score)
        let scene = GameOverView(size: size)
        scene.scaleMode = scaleMode
        view!.presentScene (scene, transition: .doorsCloseVertical(withDuration: 0.8))
    }
    
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        if let playerNode = firstBody.node as? SKSpriteNode,
            let wasteNode = secondBody.node as? SKSpriteNode,
            let wasteType = wasteNode.userData?.value(forKey: "wasteType") as? String {
            let playerCategory = currentBin

            if playerCategory == "bianco" {
                if wasteType.hasPrefix("paper") {
                    collisionFunc(player: playerNode, waste: wasteNode)
                } else {
                    notCollisionFunc(waste: wasteNode)
                }
            } else if playerCategory == "giallo" {
                if wasteType.hasPrefix("plastic") {
                    collisionFunc(player: playerNode, waste: wasteNode)
                } else {
                    notCollisionFunc(waste: wasteNode)
                }
            } else if playerCategory == "marrone" {
                if wasteType.hasPrefix("indifferenziato") {
                    collisionFunc(player: playerNode, waste: wasteNode)
                } else {
                    notCollisionFunc(waste: wasteNode)
                }
            } else {
                notCollisionFunc(waste: wasteNode)
            }
        }
        
    }
}
