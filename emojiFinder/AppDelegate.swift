//
//  AppDelegate.swift
//  emojiFinder
//
//  Created by Vlad on 16.11.2017.
//  Copyright © 2017 Vlad. All rights reserved.
//

import UIKit
import SwiftyBeaver
import Crashlytics
import Fabric
import CoreData

fileprivate let log = SwiftyBeaver.self

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //init SwiftyBeaver
        let console = ConsoleDestination()
        log.addDestination(console)
        
        //init Crashlytic
//        FirebaseApp.configure()
//        Fabric.with([Crashlytics.self])
        
        window = UIWindow(frame: UIScreen.main.bounds)
        //setLoadingVC()
        
        setMainVC()
        
        forTest()
        
        return true
    }
    
    func forTest() {
        let entityDescription = NSEntityDescription.entity(forEntityName: "GameResult", in: self.managedObjectContext)

        let managedObject = GameResult(entity: entityDescription!, insertInto: self.managedObjectContext)
        
        // Установка значения атрибута
        managedObject.user_name = "Pither"// .setValue("Pither", forKey: "user_name")
        managedObject.setValue(10, forKey: "actions")
        managedObject.setValue(20, forKey: "time")
        managedObject.setValue(1, forKey: "complexity")
        
        // Извлечение значения атрибута
        let name = managedObject.value(forKey: "user_name")
        print("name = \(name)")
        
        // Запись объекта
        self.saveContext()
        
        // Извление записей
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GameResult")
        do {
            let results = try self.managedObjectContext.fetch(fetchRequest)
            for result in results as! [GameResult] {
                print("name - \(result.user_name!)")
            }
        } catch {
            print(error)
        }
    }
    
    func setLoadingVC() {
        let vc = LoadingViewController.storyboardInstance
        window?.rootViewController = vc
    }
    
    func setMainVC() {
        let vc = MainNavigationController.storyboardInstance
        window?.rootViewController = vc
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Core Data stack
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "main", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}
