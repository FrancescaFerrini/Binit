//
//  ContentView.swift
//  Game Buster
//
//  Created by Francesca Ferrini on 10/12/23.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    
    private var screenWidth: CGFloat { UIScreen.main.bounds.size.width }
    private var screenHeight: CGFloat { UIScreen.main.bounds.size.height }
    
    var scene : SKScene{
        let scene = MainMenu()
        scene.size = CGSize(width: screenWidth, height: screenHeight)
        scene.scaleMode = .fill
        return scene
    }
    
    
    
    var body: some View {
        
        SpriteView(scene: scene)
            .frame(width: screenWidth,height: screenHeight).ignoresSafeArea(.all)
        
    }
}

#Preview {
    ContentView()
}
