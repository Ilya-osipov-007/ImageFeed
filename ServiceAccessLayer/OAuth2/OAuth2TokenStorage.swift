//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Илья Геннадьевич on 15.04.2026.
//

import Foundation
final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private let tokenKey = "OAuth2TokenStorage.token"
    private let userDefaults = UserDefaults.standard
    var token: String? {
        get {
            userDefaults.string(forKey: tokenKey)
        }
        set {
            userDefaults.set(newValue, forKey: tokenKey)
        }
    }
    private init() {}
}
