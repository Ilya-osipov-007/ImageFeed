//
//  WebViewTests.swift
//  ImageFeed Tests
//
//  Created by Илья Геннадьевич on 11.06.2026.
//

import XCTest
import UIKit
@testable import ImageFeed

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: WebViewViewControllerProtocol?

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func didUpdateProgressValue(_ newValue: Double) {}

    func code(from url: URL) -> String? {
        return nil
    }
}

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: WebViewPresenterProtocol?
    var loadRequestCalled: Bool = false

    func load(request: URLRequest) {
        loadRequestCalled = true
    }

    func setProgressValue(_ newValue: Float) {}
    func setProgressHidden(_ isHidden: Bool) {}
}

// MARK: - Profile Spies

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol?
    var viewDidLoadCalled = false
    var didTapLogoutCalled = false

    func viewDidLoad() { viewDidLoadCalled = true }
    func didTapLogout() { didTapLogoutCalled = true }
}

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    var updateAvatarCalled = false
    var updateProfileDetailsCalled = false
    var showLogoutAlertCalled = false

    func updateAvatar(url: URL) { updateAvatarCalled = true }
    func updateProfileDetails(name: String, loginName: String, bio: String) { updateProfileDetailsCalled = true }
    func showLogoutAlert() { showLogoutAlertCalled = true }
}

// MARK: - ImagesList Spies

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    var photos: [Photo] = []
    var viewDidLoadCalled = false
    var fetchNextPageCalled = false

    func viewDidLoad() { viewDidLoadCalled = true }
    func fetchNextPage() { fetchNextPageCalled = true }
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {}
}

// MARK: - Tests

final class WebViewTests: XCTestCase {

    func testViewControllerCallsViewDidLoad() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController

        //when
        _ = viewController.view

        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }

    func testPresenterCallsLoadRequest() {
        //given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let viewController = WebViewViewControllerSpy()
        presenter.view = viewController
        viewController.presenter = presenter

        //when
        presenter.viewDidLoad()

        //then
        XCTAssertTrue(viewController.loadRequestCalled)
    }

    func testProgressVisibleWhenLessThenOne() {
        //given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6

        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)

        //then
        XCTAssertFalse(shouldHideProgress)
    }

    func testProgressHiddenWhenOne() {
        //given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1.0

        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)

        //then
        XCTAssertTrue(shouldHideProgress)
    }

    func testAuthHelperAuthURL() {
        //given
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)

        //when
        let url = authHelper.authURL()

        guard let urlString = url?.absoluteString else {
            XCTFail("Auth URL is nil")
            return
        }

        //then
        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
    }

    func testCodeFromURL() {
        //given
        let authHelper = AuthHelper()
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")!
        urlComponents.queryItems = [URLQueryItem(name: "code", value: "test code")]
        guard let url = urlComponents.url else {
            XCTFail("Failed to build URL")
            return
        }

        //when
        let code = authHelper.code(from: url)

        //then
        XCTAssertEqual(code, "test code")
    }

    // MARK: - Profile tests

    func testProfileViewControllerCallsPresenterViewDidLoad() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.configure(presenter)

        //when
        _ = viewController.view

        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }

    func testProfilePresenterCallsShowLogoutAlertOnTap() {
        //given
        let presenter = ProfilePresenter()
        let view = ProfileViewControllerSpy()
        presenter.view = view

        //when
        presenter.didTapLogout()

        //then
        XCTAssertTrue(view.showLogoutAlertCalled)
    }

    // MARK: - ImagesList tests

    func testImagesListViewControllerCallsPresenterViewDidLoad() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        ) as! ImagesListViewController
        let presenter = ImagesListPresenterSpy()
        viewController.configure(presenter)

        //when
        _ = viewController.view

        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
}
