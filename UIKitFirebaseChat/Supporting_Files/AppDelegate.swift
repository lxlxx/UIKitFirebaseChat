//
//  AppDelegate.swift
//  UIKitFirebaseChat
//
//  Created by yu fai on 9/2/2023.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = UIColor.white
        window?.rootViewController = UINavigationController(rootViewController: MessageVC())
        
        return true
    }



}

