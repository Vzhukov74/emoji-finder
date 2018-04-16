//
//  CoreDataExt.swift
//  emojiFinder
//
//  Created by Vlad on 11.04.2018.
//  Copyright © 2018 Vlad. All rights reserved.
//

import CoreData

protocol EntityCreating {
    init(within context: NSManagedObjectContext)
}

extension EntityCreating where Self: NSManagedObject {
    init(within context: NSManagedObjectContext = CoreDataManager.shared.managedObjectContext) {
        self = NSEntityDescription.insertNewObject(forEntityName: "\(Self.self)", into: context) as! Self
    }
}
