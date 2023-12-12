//
//  SettingsMenu.swift
//  Game Buster
//
//  Created by Fernando Sensenhauser on 12/12/23.
//

import Foundation
import SpriteKit

class SettingsMenu: SKScene {
    let backImage = SKSpriteNode(imageNamed: "settingsImage")
    
    override func didMove(to view: SKView) {
        backImage.size = CGSize(width: frame.size.width, height: frame.size.height)
        backImage.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        backImage.alpha = 0.8
        backImage.zPosition = -1
        addChild(backImage)
    }
}
