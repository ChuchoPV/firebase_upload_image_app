//
//  AppDelegate.swift
//  firebase_upload_app
//
//  Created by Jesús Perea (Mobile Engineer) on 25/09/22.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        doFirebase()
        doAppCoordinator()
        
        return true
    }
}

extension AppDelegate {
    
    func doFirebase() {
        FirebaseApp.configure()
    }
    
    func doAppCoordinator() {
        
        window = UIWindow()
        
        guard let window = (UIApplication.shared.delegate as? AppDelegate)?.window else {
            return
        }
        
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        let main = MainViewController()
        
        navigationController.pushViewController(main, animated: true)
    }
}
