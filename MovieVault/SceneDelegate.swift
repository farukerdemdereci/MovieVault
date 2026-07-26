//
//  SceneDelegate.swift
//  MovieVault
//
//  Created by Faruk on 30.06.2026.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var coordinator: Coordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }

        let window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()

        self.coordinator = AppCoordinator(navigationController: navigationController)
        coordinator?.start()

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        self.window = window
    }
}
