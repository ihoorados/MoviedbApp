//
//  AppDelegate.swift
//  MoviedbApp
//
//  Created by Hoorad on 1/14/25.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: ApplicationCoordinator?
    let applicationDIContainer = ApplicationDIContainer()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        window?.rootViewController = navigationController
        coordinator = ApplicationCoordinator(navigationController: navigationController, applicationDIContainer: applicationDIContainer)
        coordinator?.start()
        window?.makeKeyAndVisible()
        return true
    }
    
}

