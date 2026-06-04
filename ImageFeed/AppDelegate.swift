//
//  AppDelegate.swift
//  ImageFeed
//
//  Created by Илья Геннадьевич on 05.02.2026.
//

import UIKit
import ProgressHUD

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        ProgressHUD.animationType = .activityIndicator
        ProgressHUD.colorHUD = .white
        ProgressHUD.colorAnimation = .black
        return true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        makeSceneConfiguration(for: connectingSceneSession)
    }

    private func makeSceneConfiguration(
        for session: UISceneSession
    ) -> UISceneConfiguration {
        let configuration = UISceneConfiguration(
            name: "Main",
            sessionRole: session.role
        )
        configuration.delegateClass = SceneDelegate.self
        return configuration
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }


}

