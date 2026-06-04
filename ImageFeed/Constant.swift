//
//  Constant.swift
//  ImageFeed
//
//  Created by Илья Геннадьевич on 27.02.2026.
//
import Foundation

enum Constants {
    static let accessKey = "JWwuj6bDJj15caYjfJcDtC9vCTMioYsovdbkflRFPeM"
    static let secretKey = "nnwSSXvV6qFlNlwI4bVrhlOm8xqJJrX5E218MfMJvFw"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")
    static let photosPath = "photos"
    static let likePath = "like"
}
