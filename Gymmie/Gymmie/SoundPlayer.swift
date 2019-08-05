//
//  SoundPlayer.swift
//  Gymmie
//
//  Created by Blake Rogers on 10/24/16.
//  Copyright © 2016 T3. All rights reserved.
//


import UIKit
import AVFoundation
import AVKit

struct SoundPlayer{
    

    
 static func playSound(sound: String, type: String){
    
    guard let url = Bundle.main.url(forResource: sound, withExtension: type) else{return }
        let fileManager = FileManager()
    if fileManager.fileExists(atPath: url.path){
        do{
            let soundPlayer = try AVAudioPlayer(contentsOf: url )
          // try AVAudioSession.sharedInstance().setActive(true)
            soundPlayer.play()
           try AVAudioSession.sharedInstance().setActive(false)
        }catch{
            print("sound file \(sound) does not exist. Try again bub")
            }
        
        }
    }
  
}
