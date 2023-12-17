//
//  OnBoarding.swift
//  Game Buster
//
//  Created by Ylenia Spagnuolo on 16/12/23.
//

import SwiftUI
import SpriteKit

struct OnBoardigStep {
    let title: String
    let image: String
    let details: String
}


private let onBoardingSteps = [
    OnBoardigStep(title: "Hi! I'm Binny", image: "trashImage", details: "I like to collect the unindifference waste"),
    OnBoardigStep(title: "Hi! I'm Recy", image: "Bianco", details: "I like to collect the paper waste"),
    OnBoardigStep(title: "Hi! I'm Ecoly", image: "Ecoly", details: "I like to collect the plastic and alluminium waste")
]
struct OnBoarding: View {
    @State private var currentStep = 0
    private var screenWidth: CGFloat { UIScreen.main.bounds.size.width }
    private var screenHeight: CGFloat { UIScreen.main.bounds.size.height }
    
    
    init() {
        UIScrollView.appearance().bounces = false
    }
    
    var body: some View {
        
        VStack{
            HStack{
                Spacer()
                Button(action: {
                    self.currentStep = onBoardingSteps.count - 1
                }){
                    Text("Skip")
                        .padding(16)
                        .foregroundColor(.green)
                }
            }
            
            TabView(selection: $currentStep){
                ForEach(0..<onBoardingSteps.count) { it in
                    VStack{
                        Text (onBoardingSteps[it].title)
                            .font(.title)
                            .fontWeight(.bold)
                            .kerning(1.2)
                            .padding(.top)
                        
                        //Kerning defines the offset, in points, that a text view should shift characters from the default spacing. Use positive kerning to widen the spacing between characters. Use negative kerning to tighten the spacing between characters
                        
                        Spacer(minLength: 50)
                        
                        Image (onBoardingSteps[it].image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.horizontal, 16)
                        
                        Spacer(minLength: 30)
                        
                        Text(onBoardingSteps[it].details)
                            .font(.body)
                            .fontWeight(.semibold)
                            .kerning(1.2)
                            .padding()
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                        
                    }
                    .tag(it)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
           HStack{
                ForEach(0..<onBoardingSteps.count) { it in
                    if it == currentStep {
                        Rectangle()
                            .frame(width: 20, height: 10)
                            .cornerRadius(10)
                            .foregroundColor(.green)
                    } else {
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundColor(.green)
                    }
                }
            }
            .padding(.bottom, 24)
            
            Button(action: {
                if self.currentStep < onBoardingSteps.count - 1 {
                    self.currentStep += 1
                } else {
                    var scene : SKScene{
                        let scene = MainMenu()
                        scene.size = CGSize(width: screenWidth, height: screenHeight)
                        scene.scaleMode = .fill
                        AudioManager.shared.playBackgroundMusic()

                        return scene
                    }
                }
            }) {
                Text(currentStep < onBoardingSteps.count - 1 ? "Next" : "Get started")
                    .padding(16)
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(16)
                    .padding(.horizontal, 16)
                    .foregroundColor(.white)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
                    
    
    struct OnBoarding_Preview: PreviewProvider {
        static var previews: some View {
        OnBoarding()
        }
    }
    
}
