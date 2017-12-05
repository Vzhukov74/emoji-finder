//
//  SoundEngine.swift
//  emojiFinder
//
//  Created by Vlad on 05.12.2017.
//  Copyright © 2017 Vlad. All rights reserved.
//

import Foundation
import AVFoundation
import AudioToolbox

class SoundEngine {
    
    var player = AVAudioPlayer()
    
    func playOpenCellSound() {
    
    }
    
    func playCoincidenceSound() {
        
        let sound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "coincidence", ofType: "wav")!)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            try player = AVAudioPlayer(contentsOf: sound as URL)
            player.prepareToPlay()
            player.play()
            vibration()
        } catch {
            
        }
    }
    
    func playPlayEndSound() {
        
    }
    
    fileprivate func vibration() {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
    }
}
