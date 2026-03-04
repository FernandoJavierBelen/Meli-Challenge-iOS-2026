//
//  AppCoordinator.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 02/03/2026.
//

import UIKit
import SwiftUI

@MainActor
final class AppCoordinator: @preconcurrency CoordinatorProtocol {

    let navigationController: UINavigationController
    private let window: UIWindow
    private let notificationManager: NotificationPermissionProtocol

    init(
        window: UIWindow,
        notificationManager: NotificationPermissionProtocol = NotificationPermissionManager()
    ) {
        self.window = window
        self.navigationController = UINavigationController()
        self.notificationManager = notificationManager
    }

    func start() {
        showSplash()
    }
    
    private func showSplash() {
        let splash = SplashViewController()
        
        splash.onFinished = { [weak self] in
            self?.transitionToMain()
        }
        
        window.rootViewController = splash
        window.makeKeyAndVisible()
    }
    
    private func transitionToMain() {
        let viewModel = ArticleListViewModel()
        let rootView = ArticleListView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: rootView)
        
        navigationController.setViewControllers([hostingController], animated: false)
        navigationController.isNavigationBarHidden = true
        
        window.rootViewController = navigationController
        notificationManager.requestPermissionIfNeeded()
    }
}
