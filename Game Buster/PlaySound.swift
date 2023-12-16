//
//  PlaySound.swift
//  Game Buster
//
//  Created by Francesca Ferrini on 16/12/23.
//

import Foundation
import AVFoundation

var audioPlayer: AVAudioPlayer?

/*func playSound(sound: String, type: String){
    if let path = Bundle.main.path(forResource: sound, ofType: type){
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        }catch{
            print("ERROR SOUND")
        }
    }
}*/

/*func playSound(sound: String?, type: String?){
    let newsound = "NuovoBacgroundLoop"
    sound = newsound
    if let path = Bundle.main.path(forResource: sound, ofType: "mp3"){
        let url = URL(fileURLWithPath: path)
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        }catch{
            print("ERROR SOUND")
        }
    }
        
}*/
