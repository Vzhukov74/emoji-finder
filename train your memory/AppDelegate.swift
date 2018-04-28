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
        //FirebaseApp.configure()
        //Fabric.with([Crashlytics.self])
        
        window = UIWindow(frame: UIScreen.main.bounds)
        //setLoadingVC()
        
        setMainVC()
        return true
    }
        
//    func setLoadingVC() {
//        let vc = LoadingViewController.storyboardInstance
//        window?.rootViewController = vc
//    }
    
    func setMainVC() {
        let vc = MainNavigationController.storyboardInstance
        window?.rootViewController = vc
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        NotificationCenter.default.post(Notification(name: NotificationNames.appEnterInBackground))
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
