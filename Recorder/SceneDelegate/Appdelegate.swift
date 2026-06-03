//
//  Appdelegate.swift
//  AppStoreTabbbar
//
//  Created by Suraj Kumbhar on 03/06/26.
//

import UIKit

class Appdelegate: NSObject {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
                         launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            return true
        }
        
        func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
            
            let sceneConfig : UISceneConfiguration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
            sceneConfig.delegateClass = SceneDelegate.self
            return sceneConfig
            
        }
}
