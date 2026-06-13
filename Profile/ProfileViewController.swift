//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Илья Геннадьевич on 08.02.2026.
//
import UIKit
import Kingfisher
import WebKit

final class ProfileViewController: UIViewController {
    var presenter: ProfilePresenterProtocol?

    private let imageView = UIImageView()
    private let logoutButton = UIButton()
    private let loginNameLabel = UILabel()
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()

    func configure(_ presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        presenter.view = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }

    @objc private func didTapLogoutButton() {
        presenter?.didTapLogout()
    }

    private func performLogout() {
        OAuth2TokenStorage.shared.token = nil
        HTTPCookieStorage.shared.removeCookies(since: .distantPast)
        WKWebsiteDataStore.default().removeData(
            ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(),
            modifiedSince: .distantPast
        ) { [weak self] in
            guard let self, let window = self.view.window else { return }
            window.rootViewController = SplashViewController()
        }
    }

    private func setupImageView() {
        imageView.image = UIImage(named: "Avatar")
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
    }

    private func setuplogoutButton() {
        logoutButton.setImage(UIImage(named: "Exit"), for: .normal)
        logoutButton.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
        logoutButton.accessibilityIdentifier = "logout button"
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
    }

    private func setupLoginNameLabel() {
        loginNameLabel.font = UIFont.systemFont(ofSize: 13)
        loginNameLabel.textColor = UIColor(named: "ypGray")
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
    }

    private func setupNameLabel() {
        nameLabel.textColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
    }

    private func setupDiscriptionLabel() {
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.textColor = .white
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            loginNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
        ])
    }

    private func setupUI() {
        view.backgroundColor = UIColor(named: "ypBlack")
        setupImageView()
        setuplogoutButton()
        setupLoginNameLabel()
        setupNameLabel()
        setupDiscriptionLabel()
        setupConstraints()
    }
}

extension ProfileViewController: ProfileViewControllerProtocol {
    func updateAvatar(url: URL) {
        let placeholderImage = UIImage(systemName: "person.circle.fill")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 70, weight: .regular, scale: .large))
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: url,
            placeholder: placeholderImage,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage,
                .forceRefresh
            ]
        )
    }

    func updateProfileDetails(name: String, loginName: String, bio: String) {
        nameLabel.text = name
        loginNameLabel.text = loginName
        descriptionLabel.text = bio
    }

    func showLogoutAlert() {
        let alert = UIAlertController(
            title: NSLocalizedString("logout.alert.title", comment: ""),
            message: NSLocalizedString("logout.alert.message", comment: ""),
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: NSLocalizedString("logout.alert.cancel", comment: ""), style: .default))
        alert.addAction(UIAlertAction(title: NSLocalizedString("logout.alert.confirm", comment: ""), style: .destructive) { [weak self] _ in
            self?.performLogout()
        })
        present(alert, animated: true)
    }
}
