import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    var imageURL: URL?

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var backButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        let backImage = (UIImage(named: "Backward") ?? UIImage(systemName: "chevron.backward"))?
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        backButton.setImage(backImage, for: .normal)
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        loadImage()
    }

    private func loadImage() {
        guard let imageURL else { return }
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: imageURL) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self else { return }
            if case .failure = result {
                self.showError()
            }
        }
    }

    private func showError() {
        let alert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Попробовать ещё раз?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Не надо", style: .cancel))
        alert.addAction(UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            self?.loadImage()
        })
        present(alert, animated: true)
    }

    @IBAction private func didTapShareButton(_ sender: Any) {
        guard let image = imageView.image else { return }
        let share = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(share, animated: true)
    }

    @IBAction private func didTapBackButton() {
        dismiss(animated: true)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
