//
//  Constants.swift
//  emojiFinder
//
//  Created by Vlad on 01.03.2018.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit

class Constants {
    static let pixelIconsIds = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16"]
}

class Colors {
    static let menuText = UIColor(red: 235/255, green: 61/255, blue: 0/255, alpha: 1)
    
    static let gradientStart = UIColor(red: 195/255, green: 224/255, blue: 213/255, alpha: 1)
    static let gradientEnd = UIColor(red: 241/255, green: 243/255, blue: 251/255, alpha: 1)
    
    class func addGradientBackgroundOn(view: UIView, with frame: CGRect) {
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.colors = [Colors.gradientStart.cgColor, Colors.gradientEnd.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.frame = frame
        
        view.layer.insertSublayer(gradient, at: 0)
    }
}

class Fonts {
    static let menuFont = UIFont(name: "PressStart2P", size: 20)!
    static let timeFont = UIFont(name: "PressStart2P", size: 14)!
    static let segmentedControlFont = UIFont(name: "PressStart2P", size: 10)!
    static let statisticsTitleFont = UIFont(name: "PressStart2P", size: 8)!
}

class NotificationNames {
    static let playAgainNotification = Notification.Name(rawValue: "ru.playAgainNotification")
    static let appEnterInBackground = Notification.Name(rawValue: "ru.appEnterInBackground")
}

class Images {
    static let play = UIImage(named: "play")!
    static let pause = UIImage(named: "pause")!
}
