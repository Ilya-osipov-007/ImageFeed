//
//  ProfilePresenter.swift
//  ImageFeed
//

import Foundation
import WebKit

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func updateAvatar(url: URL)
    func updateProfileDetails(name: String, loginName: String, bio: String)
    func showLogoutAlert()
}

protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func didTapLogout()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    private var profileImageServiceObserver: NSObjectProtocol?

    func viewDidLoad() {
        if let profile = ProfileService.shared.profile {
            let name = profile.name.isEmpty ? "Имя не указано" : profile.name
            let loginName = profile.loginName.isEmpty ? "@неизвестный_пользователь" : profile.loginName
            let bio = (profile.bio?.isEmpty ?? true) ? "Профиль не заполнен" : (profile.bio ?? "")
            view?.updateProfileDetails(name: name, loginName: loginName, bio: bio)
        }

        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateAvatar()
        }
        updateAvatar()
    }

    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        view?.updateAvatar(url: url)
    }

    func didTapLogout() {
        view?.showLogoutAlert()
    }
}
