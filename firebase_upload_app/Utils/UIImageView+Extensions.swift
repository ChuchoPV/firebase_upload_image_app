//
//  UIImage+Extensions.swift
//  firebase_upload_app
//
//  Created by Jesús Perea (Mobile Engineer) on 25/09/22.
//

import Foundation
import UIKit

public extension UIImageView {
    
    func imageFromUrl(url: URL) {
        
        self.image = UIImage(named: "empty_image")
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }
        
        task.resume()
    }
}
