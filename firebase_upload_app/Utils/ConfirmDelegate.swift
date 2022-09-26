//
//  ConfirmDelegate.swift
//  firebase_upload_app
//
//  Created by Jesús Perea (Mobile Engineer) on 25/09/22.
//

import Foundation
import UIKit

public protocol ConfirmDelegate: AnyObject {
    
    func didConfirm(image: UIImage, path: String?)
    func didCancel()
}
