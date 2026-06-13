import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!

    var presenter: ImagesListPresenterProtocol?

    private let showSingleImageSegueIdentifier = "ShowSingleImage"

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

    func configure(_ presenter: ImagesListPresenterProtocol) {
        self.presenter = presenter
        presenter.view = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        presenter?.viewDidLoad()
    }
}

extension ImagesListViewController: ImagesListViewControllerProtocol {
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        tableView.performBatchUpdates {
            let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.photos.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.reuseIdentifier,
            for: indexPath
        )
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        configCell(for: imageListCell, with: indexPath)
        imageListCell.delegate = self
        return imageListCell
    }
}

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let photo = presenter?.photos[indexPath.row] else { return }
        let placeholder = UIImage(named: "Stub_wallpapers")

        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(
            with: URL(string: photo.thumbImageURL),
            placeholder: placeholder
        ) { [weak tableView] _ in
            tableView?.reloadRows(at: [indexPath], with: .none)
        }

        cell.dateLabel.text = photo.createdAt.map { dateFormatter.string(from: $0) } ?? ""

        let likeImage = UIImage(resource: photo.isLiked ? .likeButtonOn : .likeButtonOff)
        cell.likeButton.setImage(likeImage, for: .normal)
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }

    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if indexPath.row == (presenter?.photos.count ?? 0) - 1 {
            presenter?.fetchNextPage()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath,
                let url = presenter?.photos[indexPath.row].largeImageURL
            else {
                print("Invalid segue destination")
                return
            }
            viewController.imageURL = URL(string: url)
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let photo = presenter?.photos[indexPath.row], photo.size.width > 0 else { return 0 }

        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let scale = imageViewWidth / photo.size.width
        return photo.size.height * scale + imageInsets.top + imageInsets.bottom
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell),
              let photo = presenter?.photos[indexPath.row] else { return }

        UIBlockingProgressHUD.show()
        presenter?.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                cell.setIsLiked(self.presenter?.photos[indexPath.row].isLiked ?? false)
                UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
}
