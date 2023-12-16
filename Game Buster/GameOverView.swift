//
//  MainMenu.swift
//  Game Buster
//
//  Created by Fernando Sensenhauser on 12/12/23.
//

import Foundation
import SpriteKit

class GameOverView: SKScene {
    
    var clouds: SKEmitterNode!
    let back = SKSpriteNode (imageNamed: "skyGradient")
  

    override func didMove(to view: SKView) {
    
        
        createBackground()
        createNode()

        run(.sequence([
            .wait(forDuration: 2.0),
            .run {
                let scene = MainMenu(size: self.size)
                scene.scaleMode = self.scaleMode
                self.view!.presentScene(scene, transition: .doorsOpenVertical(withDuration: 1))
            }
        ]))
    }
    
    func createBackground () {
        back.size = CGSize(width: frame.size.width, height: frame.size.height)
        back.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        back.alpha = 0.8
        back.zPosition = -1
        addChild(back)
        
        clouds = SKEmitterNode(fileNamed: "Clouds")
        clouds.position = CGPoint(x: 150, y: 900)
        clouds.zPosition = -1
        clouds.advanceSimulationTime(10)
        addChild(clouds)

    }
    
    func createNode(){
        let gameOver = SKSpriteNode(imageNamed: "GameOver")
        gameOver.position = CGPoint(x: size.width/2, y: size.height/2-90)
        gameOver.setScale(1.5)
        addChild(gameOver)
        let scaleUp = SKAction.scale(to: 0.7, duration: 0.3)
        let scaleDown = SKAction.scale(to: 0.5, duration: 0.3)
        let fullScale = SKAction.sequence ( [scaleUp, scaleDown])
        gameOver.run(.repeatForever(fullScale))
    }
}
