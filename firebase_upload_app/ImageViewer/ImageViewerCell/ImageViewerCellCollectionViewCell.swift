//
//  ImageViewerCellCollectionViewCell.swift
//  firebase_upload_app
//
//  Created by Jesús Perea (Mobile Engineer) on 25/09/22.
//

import UIKit

class ImageViewerCellCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(image: URL?) {
        
        guard let url = image else {
            img.image = .init(named: "empty_image")
            return
        }
        
        img.imageFromUrl(url: url)
    }
}
