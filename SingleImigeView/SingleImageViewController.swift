//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Илья Геннадьевич on 10.02.2026.
//
import UIKit

final class SingleImageViewController: UIViewController {  //for alex
    var image: UIImage?{
        didSet {
            guard isViewLoaded else { return } // 1
            imageView.image = image // 2
        }
    }
    
    @IBOutlet private var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        
        guard let image = image else { return }
        imageView.frame.size = image.size
        //imageView.frame = CGRect(origin: .zero, size: image.size)
        // scrollView.contentSize = image.size
        rescaleAndCenterImageInScrollView(image: image)
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
       
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // сюда система вызывает код каждый раз после раскладки
        guard let image = image else { return }
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = imageSize.width > 0 ? visibleRectSize.width / imageSize.width : 1.0 //for alex
        let vScale = imageSize.height > 0 ? visibleRectSize.height / imageSize.height : 1.0 //for alex
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    @IBAction func didTapShareButton(_ sender: Any) {
        guard let image = image else { return }
        let share = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(share, animated: true, completion: nil)
    }
    
    @IBOutlet private var scrollView: UIScrollView!
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
}
    
    extension SingleImageViewController: UIScrollViewDelegate {
        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return imageView
        }
    }
    

