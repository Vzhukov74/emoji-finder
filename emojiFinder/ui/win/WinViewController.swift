//
//  WinViewController.swift
//  emojiFinder
//
//  Created by Vlad on 17.11.2017.
//  Copyright © 2017 Vlad. All rights reserved.
//

import UIKit

class WinViewController: UIViewController {

    var model: VZGameResult!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    deinit {
        print("deinit - WinViewController")
    }
}

extension WinViewController: StoryboardInstanceable {
    static var storyboardName: StoryboardList = .win
}

//    func forTest() {
//        let entityDescription = NSEntityDescription.entity(forEntityName: "GameResult", in: self.managedObjectContext)
//
//        let managedObject = GameResult(entity: entityDescription!, insertInto: self.managedObjectContext)
//
//        // Установка значения атрибута
//        managedObject.user_name = "Pither"// .setValue("Pither", forKey: "user_name")
//        managedObject.setValue(10, forKey: "actions")
//        managedObject.setValue(20, forKey: "time")
//        managedObject.setValue(1, forKey: "complexity")
//
//        // Извлечение значения атрибута
//        let name = managedObject.value(forKey: "user_name")
//        print("name = \(String(describing: name))")
//
//        // Запись объекта
//        self.saveContext()
//
//        // Извление записей
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GameResult")
//        do {
//            let results = try self.managedObjectContext.fetch(fetchRequest)
//            for result in results as! [GameResult] {
//                print("name - \(result.user_name!)")
//            }
//        } catch {
//            print(error)
//        }
//    }
