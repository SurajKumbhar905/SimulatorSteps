//
//  SceneDelegate.swift
//  AppStoreTabbbar
//
//  Created by Suraj Kumbhar on 03/06/26.
//

import UIKit

class SceneDelegate: NSObject {
    var window: UIWindow?
       
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        // Display the UI Recorder controls automatically during local development execution
        #if DEBUG
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            UITestRecorderOverlay.shared.show()
        }
        #endif
    }
       
       func sceneDidBecomeActive(_ scene: UIScene) {
           
       }
       
       func sceneDidEnterBackground(_ scene: UIScene) {
           
       }
       
       func sceneWillEnterForeground(_ scene: UIScene) {
           
       }
       
       func sceneWillResignActive(_ scene: UIScene) {
           
       }
}
