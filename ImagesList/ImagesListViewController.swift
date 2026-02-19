import UIKit // for 08 sprint

final class ImagesListViewController: UIViewController {  // for 08 sprint
    @IBOutlet private var tableView: UITableView!  // for 08 sprint
    private let today = Date() // for 08 sprint
    private var photosName: [String] = Array(0..<20).map{ "\($0)"}  // for 08 sprint
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    
    private lazy var dateFormatter: DateFormatter = {  // for 08 sprint
        let formatter = DateFormatter()  // for 08 sprint
        formatter.dateStyle = .long   // for 08 sprint
        formatter.timeStyle = .none // for 08 sprint
        return formatter // for 08 sprint
    }() // for 08 sprint
    
    override func viewDidLoad() { // for 08 sprint
        super.viewDidLoad() // for 08 sprint
        
        // tableView.rowHeight = 200 // for 08 sprint
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0) // for 08 sprint
        
    } // for 08 sprint
} // for 08 sprint

extension ImagesListViewController: UITableViewDataSource { // for 08 sprint
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // for 08 sprint
        return photosName.count // for 08 sprint
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {  // for 08 sprint
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)  // for 08 sprint
        
        guard let imageListCell = cell as? ImagesListCell else {  // for 08 sprint
            return UITableViewCell() // for 08 sprint
        } // for 08 sprint
        
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

extension ImagesListViewController { // for 08 sprint
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return
        }
        
        cell.cellImage.image = image // for 08 sprint
        cell.dateLabel.text = dateFormatter.string(from: today)
        
        let isLiked = indexPath.row % 2 == 0 // for 08 sprint
        // let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        let imageResource: ImageResource = isLiked ? .likeButtonOn : .likeButtonOff
        let images = UIImage(resource: imageResource)
        cell.likeButton.setImage(images, for: .normal)
    }
    
}

extension ImagesListViewController: UITableViewDelegate { // for 08 sprint
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,  // ← сюда кладём экран Single Image
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destinanation")
                return
            }
            
            let image = UIImage(named: photosName[indexPath.row])
            viewController.image = image // ← обращаемся к свойству image у ЭТОГО экрана
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { // for 08 sprint
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width // for 08 sprint
        let scale = imageViewWidth / imageWidth // for 08 sprint
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight // for 08 sprint
    }
}


