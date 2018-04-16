//
//  VZGameResult.swift
//  emojiFinder
//
//  Created by Vlad on 11.04.2018.
//  Copyright © 2018 Vlad. All rights reserved.
//

import Foundation

class VZGameResult {
    let time: Int64!
    let actions: Int32!
    let complexity: VZGameComplexity!
    
    init(time: Int64, actions: Int32, complexity: VZGameComplexity) {
        self.time = time
        self.actions = actions
        self.complexity = complexity
    }
    
    func tryToSaveWith(name: String) -> Bool {
        if name.isEmpty {
            return false
        } else {
            saveWith(name: name)
            return true
        }
    }
    
    private func saveWith(name: String) {
        let result = GameResult()
        result.user_name = name
        result.time = time
        result.actions = actions
        result.complexity = Int32(complexity.intValue())
        
        CoreDataManager.shared.saveContext()
    }
}
