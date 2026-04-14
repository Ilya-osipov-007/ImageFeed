//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Codex on 14.04.2026.
//

import Foundation

enum OAuth2ServiceError: Error {
    case invalidRequest
    case invalidResponse
    case httpStatusCode(Int)
    case noData
    case decodingError
}

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
        request.httpMethod = "POST"
        return request
    }

    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = makeOAuthTokenRequest(code: code) else {
            completion(.failure(OAuth2ServiceError.invalidRequest))
            return
        }

        let task = urlSession.dataTask(with: request) { data, response, error in
            if let error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(OAuth2ServiceError.invalidResponse))
                return
            }

            guard (200 ... 299).contains(httpResponse.statusCode) else {
                completion(.failure(OAuth2ServiceError.httpStatusCode(httpResponse.statusCode)))
                return
            }

            guard let data else {
                completion(.failure(OAuth2ServiceError.noData))
                return
            }

            do {
                let responseBody = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                completion(.success(responseBody.accessToken))
            } catch {
                completion(.failure(OAuth2ServiceError.decodingError))
            }
        }
        task.resume()
    }
}
