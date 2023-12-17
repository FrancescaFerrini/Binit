//
//  ScoreBoardView.swift
//  Game Buster
//
//  Created by Francesca Ferrini on 15/12/23.
//

import SwiftUI

import Foundation
import SpriteKit

class ScoreBoardView: SKScene {
    
    private var screenWidth: CGFloat { UIScreen.main.bounds.size.width }
    private var screenHeight: CGFloat { UIScreen.main.bounds.size.height }
    
    let score = SKLabelNode()
    let topScore = SKLabelNode()
    let backsymbol = SKSpriteNode(imageNamed: "Back1")
    let binBianco = SKSpriteNode (imageNamed: "bianco")
    let binGiallo = SKSpriteNode (imageNamed: "giallo")
    let binMarrone = SKSpriteNode (imageNamed: "marrone")
    let back  = SKSpriteNode (imageNamed: "back")

   
    
    override func didMove(to view: SKView) {
        
        backsymbol.name = "Back1"
        backsymbol.setScale(0.40)
        backsymbol.alpha = 1.0
        backsymbol.position = CGPoint (x: size.width/2.0 - 110, y: size.height/3 + 450)
        addChild(backsymbol)

        
        
        score.text = "Top Score: "
        score.fontSize = 40
        score.fontName = "AmericanTypewriter-Bold"
        score.fontColor = .black
        score.position = CGPoint(x: size.width/2.0 - 20, y: size.height/2.0)
        addChild(score)
        
        topScore.text = "\(ScoreGenerator.sharedInstance.getTopScore())"
        topScore.fontSize = 40
        topScore.fontName = "AmericanTypewriter-Bold"
        topScore.fontColor = .black
        topScore.position = CGPoint(x: size.width/2.0 + 100, y: size.height/2.0)
        addChild(topScore)
        
        binBianco.name = "bianco"
        binBianco.setScale(0.15)
        binBianco.position = CGPoint (x: size.width/4.0, y: size.height/2.0 - 300)
        addChild(binBianco)
        
        binGiallo.name = "giallo"
        binGiallo.setScale(0.15)
        binGiallo.position = CGPoint (x: size.width/4.0 + 100, y: size.height/2.0 - 300)
        addChild(binGiallo)
        
        binMarrone.name = "binMarrone"
        binMarrone.setScale(0.15)
        binMarrone.position = CGPoint (x: size.width/4.0 + 210, y: size.height/2.0 - 300)
        addChild(binMarrone)
        
        
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
        
        if node.name == "Back1" {
            let scene = MainMenu()
            scene.size = CGSize(width: screenWidth, height: screenHeight)
            scene.scaleMode = .fill
            view!.presentScene(scene, transition: .doorsOpenVertical(withDuration: 0.3))
        }
    }
    
}
