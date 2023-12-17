import Foundation
import AVFoundation

class AudioManager: NSObject, AVAudioPlayerDelegate {
    static let shared = AudioManager()
    
    private var backgroundMusicPlayer: AVAudioPlayer?
    var audioPlayer: AVAudioPlayer?
    
    private override init() {
        super.init()
        configureAudioSession()
    }
    
    func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error configuring audio session: \(error.localizedDescription)")
        }
    }
    
    func playBackgroundMusic() {
        stopBackgroundMusic()  // Stop the current background music if it's playing
        
        if let path = Bundle.main.path(forResource: "NuovoBacgroundLoop", ofType: "mp3") {
            do {
                backgroundMusicPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                backgroundMusicPlayer?.numberOfLoops = -1
                backgroundMusicPlayer?.delegate = self
                backgroundMusicPlayer?.play()
            } catch let error {
                print("Error playing background music: \(error.localizedDescription)")
            }
        }
    }
    
    func stopBackgroundMusic() {
        backgroundMusicPlayer?.stop()
    }
    
    func playSoundEffect(sound: String, type: String){
        
        if let path = Bundle.main.path(forResource: sound, ofType: type){
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.play()
            }catch{
                print("ERROR SOUND")
            }
        }
    }
    
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            // Optionally handle the completion of background music playback
        }
    }
}
