//
//  ImagesListPresenter.swift
//  ImageFeed
//

import Foundation

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    func updateTableViewAnimated(oldCount: Int, newCount: Int)
}

protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get }
    func viewDidLoad()
    func fetchNextPage()
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void)
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    private(set) var photos: [Photo] = []
    private let imagesListService = ImagesListService.shared

    func viewDidLoad() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handlePhotosUpdate),
            name: ImagesListService.didChangeNotification,
            object: nil
        )
        imagesListService.fetchPhotosNextPage()
    }

    @objc private func handlePhotosUpdate() {
        let oldCount = photos.count
        photos = imagesListService.photos
        let newCount = photos.count
        guard oldCount != newCount else { return }
        view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
    }

    func fetchNextPage() {
        imagesListService.fetchPhotosNextPage()
    }

    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        imagesListService.changeLike(photoId: photoId, isLike: isLike) { [weak self] result in
            guard let self else { return }
            if case .success = result {
                self.photos = self.imagesListService.photos
            }
            completion(result)
        }
    }
}
