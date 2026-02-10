//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Илья Геннадьевич on 06.02.2026.
//

import UIKit

final class ImagesListCell: UITableViewCell { // for 08 sprint
    static let reuseIdentifier = "ImagesListCell" // for 08 sprint
  
    @IBOutlet var dateBackgroundView: UIView! // for 08 sprint
    @IBOutlet var likeButton: UIButton! // for 08 sprint
    @IBOutlet var cellImage: UIImageView! // for 08 sprint
    @IBOutlet var dateLabel: UILabel! // for 08 sprint
    
    
    private let gradientLayer = CAGradientLayer() // for 08 sprint
    let baseColor = UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1) // for 08 sprint
    
    override func awakeFromNib() { // for 08 sprint
        super.awakeFromNib() // for 08 sprint // for 08 sprint
        dateBackgroundView.layer.cornerRadius = 16 // for 08 sprint
        dateBackgroundView.layer.masksToBounds = true // for 08 sprint
        dateBackgroundView.layer.maskedCorners = [ // for 08 sprint
            .layerMinXMaxYCorner, // нижний левый // for 08 sprint
            .layerMaxXMaxYCorner  // нижний правый
        ] // for 08 sprint
        gradientLayer.colors = [ // for 08 sprint
            baseColor.withAlphaComponent(0.0).cgColor, // for 08 sprint
            baseColor.withAlphaComponent(1.0).cgColor // for 08 sprint
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0) // сверху по центру // for 08 sprint
        gradientLayer.endPoint   = CGPoint(x: 0.5, y: 1.0) // снизу по центру // for 08 sprint
        
        // ВОТ ЗДЕСЬ появляется связь:
        dateBackgroundView.layer.insertSublayer(gradientLayer, at: 0) // for 08 sprint
    } // for 08 sprint
    override func layoutSubviews() { // for 08 sprint
            super.layoutSubviews() // for 08 sprint
            gradientLayer.frame = dateBackgroundView.bounds // for 08 sprint
        }
}

