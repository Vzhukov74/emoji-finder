//
//  GameResult+CoreDataProperties.swift
//  
//
//  Created by Vlad on 14.03.2018.
//
//

import Foundation
import CoreData

extension GameResult: EntityCreating {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GameResult> {
        return NSFetchRequest<GameResult>(entityName: "GameResult")
    }

    @NSManaged public var user_name: String?
    @NSManaged public var time: Int64
    @NSManaged public var actions: Int32
    @NSManaged public var complexity: Int32
}
