//
//  SceneDelegate.swift
//  task10
//
//  Created by akote on 5.11.25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else {
            fatalError("LOL, be careful, drink some water")
        }
        
        self.window = UIWindow(windowScene: scene)

        let navigationController: NavigationController
        if let restoredStack = NavigationStackManager.shared.restoreNavigationStack(), !restoredStack.isEmpty {
            navigationController = NavigationController()
            navigationController.setViewControllers(restoredStack, animated: false)
        } else {
            navigationController = NavigationController(rootViewController: NewGameViewController())
        }
        
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        
        CoreDataManager.shared.saveContext()

        if let navigationController = window?.rootViewController as? NavigationController {
            let viewControllers = navigationController.viewControllers
            NavigationStackManager.shared.saveNavigationStack(viewControllers)
        }
    }
}
