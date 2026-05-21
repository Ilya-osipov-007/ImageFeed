//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Codex on 14.04.2026.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String

    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}



final class OAuth2Service {
    static let shared = OAuth2Service()

    private init() {}

    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)

        guard lastCode != code else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }

        task?.cancel()
        lastCode = code

        guard let request = makeOAuthTokenRequest(code: code) else {
            lastCode = nil
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self = self else { return }
            self.task = nil
            self.lastCode = nil

            switch result {
            case .success(let responseBody):
                let token = responseBody.accessToken
                OAuth2TokenStorage.shared.token = token
                completion(.success(token))
            case .failure(let error):
                print("[OAuth2Service fetchOAuthToken]: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }

    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") else {
            return nil
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
        ]

        guard let authTokenURL = urlComponents.url else {
            return nil
        }

        var request = URLRequest(url: authTokenURL)
        request.httpMethod = HTTPMethod.post.rawValue
        return request
    }

    
    
}
