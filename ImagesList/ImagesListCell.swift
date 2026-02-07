//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Илья Геннадьевич on 06.02.2026.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var dateLabel: UILabel!
}
