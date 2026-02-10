//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Илья Геннадьевич on 06.02.2026.
//

import UIKit

final class ImagesListCell: UITableViewCell { // for 08 sprint
    static let reuseIdentifier = "ImagesListCell" // for 08 sprint
  
    @IBOutlet var dateBackgroundView: UIView!
    @IBOutlet var likeButton: UIButton! // for 08 sprint
    @IBOutlet var cellImage: UIImageView! // for 08 sprint
    @IBOutlet var dateLabel: UILabel! // for 08 sprint
    
    
    private let gradientLayer = CAGradientLayer()
    let baseColor = UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dateBackgroundView.layer.cornerRadius = 16
        dateBackgroundView.layer.masksToBounds = true
        dateBackgroundView.layer.maskedCorners = [
            .layerMinXMaxYCorner, // нижний левый
            .layerMaxXMaxYCorner  // нижний правый
        ]
        gradientLayer.colors = [
            baseColor.withAlphaComponent(0.0).cgColor,
            baseColor.withAlphaComponent(1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0) // сверху по центру
        gradientLayer.endPoint   = CGPoint(x: 0.5, y: 1.0) // снизу по центру
        
        // ВОТ ЗДЕСЬ появляется связь:
        dateBackgroundView.layer.insertSublayer(gradientLayer, at: 0)
    } // for 08 sprint
    override func layoutSubviews() {
            super.layoutSubviews()
            gradientLayer.frame = dateBackgroundView.bounds
        }
}

