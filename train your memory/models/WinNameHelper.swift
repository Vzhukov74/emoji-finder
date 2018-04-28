//
//  WinNameHelper.swift
//  train your memory
//
//  Created by Vlad on 26.04.2018.
//  Copyright © 2018 Vlad. All rights reserved.
//

import Foundation

class WinNameHelper {
    private static let nameKey = "md.nameKey"
    
    static func getName() -> String? {
        if let value = UserDefaults.standard.value(forKey: WinNameHelper.nameKey) {
            return value as? String ?? nil
        } else {
            return nil
        }
    }
    
    static func save(name: String) {
        UserDefaults.standard.set(name, forKey: WinNameHelper.nameKey)
    }
}
