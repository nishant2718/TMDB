//
//  SceneDelegate.swift
//  TMDB
//
//  Created by Nishant Patel on 7/24/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window.windowScene = windowScene
        window.rootViewController = ViewController()
        window.makeKeyAndVisible()
        
        self.window = window
    }

    // NOTE: The below are important methods, but not for this kind of small app.
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // no-op
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // no-op
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // no-op
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // no-op
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // no-op
    }
}
