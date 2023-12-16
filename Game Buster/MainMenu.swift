
//
//  MainMenu.swift
//  Game Buster
//
//  Created by Fernando Sensenhauser on 12/12/23.
//

import Foundation
import SpriteKit

class MainMenu: SKScene {
    private var screenWidth: CGFloat { UIScreen.main.bounds.size.width }
    private var screenHeight: CGFloat { UIScreen.main.bounds.size.height }
    
    let binit = SKSpriteNode (imageNamed: "binit")
    let trashImage = SKSpriteNode (imageNamed: "trashImage")
    let startButton = SKSpriteNode (imageNamed: "startButton")
    let settingsButton  = SKSpriteNode (imageNamed: "settingsButton")
    let learnButton  = SKSpriteNode (imageNamed: "learnButton")
    let back = SKSpriteNode (imageNamed: "skyGradient")
    
    var clouds: SKEmitterNode!

    override func didMove(to view: SKView) {
        clouds = SKEmitterNode(fileNamed: "Clouds")
        clouds.position = CGPoint(x: 150, y: 900)
        clouds.zPosition = -1
        clouds.advanceSimulationTime(10)
        addChild(clouds)
        
        binit.name = "binit"
        binit.position = CGPoint (x: size.width/2.0, y: size.height/2.0 + 300)
        addChild(binit)
        
        trashImage.name = "trashImage"
        trashImage.position = CGPoint (x: size.width/2.0, y: size.height/2.0 + 50)
        addChild(trashImage)
        
        startButton.name = "startButton"
        startButton.position = CGPoint (x: size.width/2.0, y: size.height/3)
        addChild(startButton)
        
        settingsButton.name = "settingsButton"
        settingsButton.position = CGPoint (x: size.width/3.0 - 25, y: size.height/5)
        addChild(settingsButton)
        
        learnButton.name = "learnButton"
        learnButton.position = CGPoint (x: size.width/2.0 + 100, y: size.height/5)
        addChild(learnButton)
        
        back.size = CGSize(width: frame.size.width, height: frame.size.height)
        back.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        back.alpha = 0.8
        back.zPosition = -1
        addChild(back)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else {return}
        let node = atPoint(touch.location(in: self))
        
        if node.name == "startButton" {
            let scene = GameScene()
            scene.size = CGSize(width: screenWidth, height: screenHeight)
            scene.scaleMode = .fill
            view!.presentScene(scene, transition: .doorsOpenVertical(withDuration: 0.3))
        }
        
        if node.name == "settingsButton" {
            let scene = SettingsMenu()
            scene.size = CGSize(width: screenWidth, height: screenHeight)
            scene.scaleMode = .fill
            view!.presentScene(scene, transition: .doorsOpenVertical(withDuration: 0.3))
        }
        
        if node.name == "learnButton" {
            let scene = ScoreBoardView()
            scene.size = CGSize(width: screenWidth, height: screenHeight)
            scene.scaleMode = .fill
            view!.presentScene(scene, transition: .doorsOpenVertical(withDuration: 0.3))
        }
    }
    
}
