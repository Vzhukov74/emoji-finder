//
//  VZGameResult.swift
//  emojiFinder
//
//  Created by Vlad on 11.04.2018.
//  Copyright © 2018 Vlad. All rights reserved.
//

import Foundation
import CoreData
import SwiftyBeaver

class VZGameResult {
    let time: Int64!
    let actions: Int32!
    let complexity: VZGameComplexity!
    
    init(time: Int64, actions: Int32, complexity: VZGameComplexity) {
        self.time = time
        self.actions = actions
        self.complexity = complexity
    }
    
    func timeAsString() -> String {
        return VZTimerFormatter.timeAsStringFor(time: Double(self.time))
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
        let coordinator = CoreDataManager.shared.persistentStoreCoordinator
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        
        let result = GameResult(within: context)
        result.user_name = name
        result.time = time
        result.actions = actions
        result.complexity = Int32(complexity.intValue())
        
        do {
            try context.save()
        } catch {
            SwiftyBeaver.error(error.localizedDescription)
        }
    }
}
