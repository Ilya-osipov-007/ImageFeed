import UIKit

struct UrlsResult: Decodable {
    let thumb: String
    let full: String
}

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String?
    let width: Int
    let height: Int
    let description: String?
    let likedByUser: Bool
    let urls: UrlsResult

    private enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width
        case height
        case description
        case likedByUser = "liked_by_user"
        case urls
    }
}

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

final class ImagesListService {
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")

    private init() {}

    private(set) var photos: [Photo] = []
    private var currentPage = 0
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared

    private static let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()

    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        guard task == nil else { return }

        let nextPage = currentPage + 1

        guard
            let token = OAuth2TokenStorage.shared.token,
            let request = makePhotosRequest(page: nextPage, token: token)
        else { return }

        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            self.task = nil

            switch result {
            case .success(let photoResults):
                let newPhotos = photoResults.map { self.convert($0) }
                self.photos.append(contentsOf: newPhotos)
                self.currentPage = nextPage
                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification,
                    object: self
                )
            case .failure(let error):
                print("[ImagesListService fetchPhotosNextPage]: \(error.localizedDescription)")
            }
        }

        self.task = task
        task.resume()
    }

    private func convert(_ result: PhotoResult) -> Photo {
        Photo(
            id: result.id,
            size: CGSize(width: result.width, height: result.height),
            createdAt: result.createdAt.flatMap { Self.dateFormatter.date(from: $0) },
            welcomeDescription: result.description,
            thumbImageURL: result.urls.thumb,
            largeImageURL: result.urls.full,
            isLiked: result.likedByUser
        )
    }

    private func makePhotosRequest(page: Int, token: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "https://api.unsplash.com/photos") else {
            return nil
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "10"),
        ]

        guard let url = urlComponents.url else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
