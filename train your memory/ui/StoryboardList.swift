//
//  StoryboardList.swift
//  emojiFinder
//
//  Created by Vlad on 17.11.2017.
//  Copyright © 2017 Vlad. All rights reserved.
//

import UIKit
import Foundation

enum StoryboardList: String {
    case main = "MainNavigationController"
    case loading = "LoadingViewController"
    case menu = "MenuViewController"
    case game = "GameViewController"
    case win = "WinViewController"
    case statistics = "StatisticsViewController"
}

protocol StoryboardInstanceable {
    static var storyboardName: StoryboardList {get set}
}

extension StoryboardInstanceable {
    static var storyboardInstance: Self? {
        let storyboard = UIStoryboard(name: storyboardName.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier:String(describing: self)) as? Self
        return vc
    }
}
