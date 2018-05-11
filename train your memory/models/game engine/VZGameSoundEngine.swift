//
//  VZGameSoundEngine.swift
//  train your memory
//
//  Created by Vlad on 26.04.2018.
//  Copyright © 2018 Vlad. All rights reserved.
//

import Foundation
import AVFoundation
import AudioToolbox
import SwiftyBeaver

class SoundConfig {
    private static let soundConfigKey = "ru.soundConfigKey"
    private static var _isSoundOn: Bool?
    
    class func isSoundOn() -> Bool {
        if SoundConfig._isSoundOn == nil {
            if let value = UserDefaults.standard.value(forKey: SoundConfig.soundConfigKey) as? Bool {
                SoundConfig._isSoundOn = value
                return SoundConfig._isSoundOn!
            } else {
                SoundConfig._isSoundOn = true
                return SoundConfig._isSoundOn!
            }
        } else {
            return SoundConfig._isSoundOn!
        }
    }
    
    class func toggleSound() {
        guard var value = SoundConfig._isSoundOn else { return }
        
        value = !value
        SoundConfig._isSoundOn = value
        
        UserDefaults.standard.set(value, forKey: SoundConfig.soundConfigKey)
    }
}

class VZGameSoundEngine {
    private var player = AVAudioPlayer()
    
    private let userGuessed = NSURL(fileURLWithPath: Bundle.main.path(forResource: "coincidence", ofType: "wav")!) as URL
    private let userOpenCell = NSURL(fileURLWithPath: Bundle.main.path(forResource: "click", ofType: "aiff")!) as URL
    private let userWon = NSURL(fileURLWithPath: Bundle.main.path(forResource: "win", ofType: "wav")!) as URL
    
    private let queue = DispatchQueue(label: "md.vz.audio")
    
    func playOpenCellSound() {
        play(melodyURL: self.userOpenCell)
    }
    
    func playCoincidenceSound() {
        play(melodyURL: self.userGuessed, isVibrationActice: true)
        vibration()
    }
    
    func playPlayEndSound() {
        play(melodyURL: self.userWon)
    }
    
    private func play(melodyURL: URL, isVibrationActice: Bool = false) {
        if !SoundConfig.isSoundOn() {
            queue.async {
                do {
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                    try AVAudioSession.sharedInstance().setActive(true)
                    
                    try self.player = AVAudioPlayer(contentsOf: melodyURL)
                    self.player.prepareToPlay()
                    self.player.play()
                    if isVibrationActice {
                        self.vibration()
                    }
                } catch {
                    SwiftyBeaver.error(error.localizedDescription)
                }
            }
        }
    }
    
    private func vibration() {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
    }
}
