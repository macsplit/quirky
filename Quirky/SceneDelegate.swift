//
//  SceneDelegate.swift
//  Quirky
//
//  Created by Lee Hanken on 23/10/2021.
//

import UIKit
import SwiftUI

func setup() -> Bool {
    let version = UserDefaults.standard.value(forKey: "version_pref") as? String ?? "0"
    
    if (version == "0") {
        
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
        UserDefaults.standard.setValue( version, forKey: "version_pref")
        
        return false
    }
    
    return true
}

func goToSettings() {
    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
}


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
            
            if (!setup()) {
    
                let alert = UIAlertController(title: "Enable keyboard",
                  message: "The keyboard can be enabled in Keyboard Settings",
                  preferredStyle: UIAlertController.Style.alert)
                
                let okAction = UIAlertAction(title: "I will",
                style: UIAlertAction.Style.default) {
                     UIAlertAction in
                    goToSettings()
                 }
                
                alert.addAction(okAction)
                
                window.rootViewController?.present(alert, animated: true, completion: nil)
                

            }
            

        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
    }


}

