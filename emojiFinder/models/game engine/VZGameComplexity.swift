//
//  VZGameComplexity.swift
//  emojiFinder
//
//  Created by Vlad on 10.04.2018.
//  Copyright © 2018 Vlad. All rights reserved.
//

import Foundation

enum VZGameComplexity: String {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    
    func intValue() -> Int {
        switch self {
        case .easy: return 0
        case .medium: return 1
        case .hard: return 2
        }
    }
    
    init(intValue: Int) {
        var value: String
        switch intValue {
        case 0: value = "Easy"
        case 1: value = "Medium"
        case 2: value = "Hard"
        default:
            value = "Easy"
            assert(false)
        }
        
        self.init(rawValue: value)!
    }
}
