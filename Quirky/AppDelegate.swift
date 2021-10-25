//
//  AppDelegate.swift
//  Quirky
//
//  Created by Lee Hanken on 23/10/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let from = Bundle.main.url(forResource: "keymapping", withExtension: "json")!

        let to = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.uk.co.hanken.quirky")!.appendingPathComponent("keymapping.json")

        if (!FileManager.default.fileExists(atPath: to.path)) {
            do {
                try FileManager.default.copyItem(at:from, to:to)
            } catch {
                print("Could not initialise default key map file")
            }
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

