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
    private let decoder = JSONDecoder()
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = makeOAuthTokenRequest(code: code) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }

        let task = urlSession.data(for: request) { [decoder] result in
            switch result {
            case .success(let data):
                do {
                    let responseBody = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    let token = responseBody.accessToken
                    OAuth2TokenStorage.shared.token = token
                    completion(.success(token))
                } catch {
                    print("[OAuth2Service] Decoding error: \(error)")
                    completion(.failure(NetworkError.decodingError(error)))
                }
            case .failure(let error):
                if case let NetworkError.httpStatusCode(statusCode) = error {
                    print("[OAuth2Service] Unsplash error, status code: \(statusCode)")
                } else if case let NetworkError.urlRequestError(urlError) = error {
                    print("[OAuth2Service] Network error: \(urlError.localizedDescription)")
                } else {
                    print("[OAuth2Service] OAuth request failed: \(error)")
                }
                completion(.failure(error))
            }
        }
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
