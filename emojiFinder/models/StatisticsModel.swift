//
//  StatisticsModel.swift
//  emojiFinder
//
//  Created by Vlad on 10.04.2018.
//  Copyright © 2018 Vlad. All rights reserved.
//

import Foundation
import CoreData

class StatisticsModel {
    
    var results = [VZGameResult]()
    
    private var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>? {
        didSet {
            self.didFetchResults?()
        }
    }
    
    var didFetchResults: (() -> Void)?
    
    init() {
        self.setFilter(complexity: VZGameComplexity.easy)
    }
    
    func setFilter(complexity: VZGameComplexity) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GameResult")
        let sortDescriptor = NSSortDescriptor(key: "complexity", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "%K == %@", "complexity", complexity.rawValue)
        fetchRequest.predicate = predicate
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.shared.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    func numberOfResults() -> Int {
        if let sections = fetchedResultsController?.sections {
            return sections[0].numberOfObjects
        } else {
            return 0
        }
    }
    
    func resultFor(index: Int) -> GameResult {
        return fetchedResultsController!.object(at: IndexPath(row: index, section: 0)) as! GameResult
    }
}
