//
//  AppDelegate.swift
//  ImageFeed
//
//  Created by Илья Геннадьевич on 05.02.2026.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {



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

