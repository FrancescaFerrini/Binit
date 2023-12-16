//
//  ScoreGenerator.swift
//  Game Buster
//
//  Created by Francesca Ferrini on 15/12/23.
//

import Foundation


class ScoreGenerator {
    
    //INIT OF ScoreGenerator INSTANCE
    static let sharedInstance = ScoreGenerator ()
    private init () {}
    
    //DECLARATION Key
    static let keyTopScore = "keyTopScore"
    static let keyScore = "keyScore"
    
    //SET/GET: CURRENT SCORE
    func setScore(_ score: Int){
        UserDefaults.standard.set(score, forKey: ScoreGenerator.keyScore)
    }
    
    func getScore() -> Int{
        return UserDefaults.standard.integer(forKey: ScoreGenerator.keyScore)
    }
    
    //SET/GET: TOP SCORE
    func setTopScore(_ highscore: Int) {
        UserDefaults.standard.set (highscore, forKey: ScoreGenerator.keyTopScore)
    }
    func getTopScore() -> Int{
        return UserDefaults.standard.integer( forKey: ScoreGenerator.keyTopScore)
    }
  
}
