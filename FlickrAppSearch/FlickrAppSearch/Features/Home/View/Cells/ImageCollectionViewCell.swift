//
//  ImageCollectionViewCell.swift
//  FlickrAppSearch
//
//  Created by Ahmed Mahdy on 20/09/2021.
//

import UIKit
import Kingfisher

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!

    public var cellPhoto: Photo? {
        didSet {
            if let photo = cellPhoto {
                guard let url = URL(string: photo.imageURL) else { return }
                image.kf.setImage(with: url)
            }
        }
    }
}
