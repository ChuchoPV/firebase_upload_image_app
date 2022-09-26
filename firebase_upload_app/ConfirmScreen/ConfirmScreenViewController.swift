//
//  ConfirmScreenViewController.swift
//  firebase_upload_app
//
//  Created by Jesús Perea (Mobile Engineer) on 25/09/22.
//

import UIKit

class ConfirmScreenViewController: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgConfirm: UIImageView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var constraintBtnCancel: NSLayoutConstraint!
    
    let image: UIImage
    let path: String?
    weak var confirmDelegate: ConfirmDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(image: UIImage, path: String?, confirmDelegate: ConfirmDelegate?) {
        
        self.image = image
        self.path = path
        self.confirmDelegate = confirmDelegate
        
        super.init(nibName: String(describing: ConfirmScreenViewController.self), bundle: Bundle(for: type(of: self)))
    }
    
    private func setup() {
        
        lblTitle.text = "¿Seguro que deseas subir esta foto?"
        imgConfirm.image = image

        btnCancel.setTitle("Cancelar", for: .normal)
        btnConfirm.setTitle("Confirmar", for: .normal)
    }
    
    private func setupLayout() {
        
        constraintBtnCancel.constant = UIScreen.main.bounds.width / 2
    }
    
    @IBAction func didPressCancel(_ sender: Any) {
        confirmDelegate?.didCancel()
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func didPressConfirm(_ sender: Any) {
        confirmDelegate?.didConfirm(image: image, path: path)
        navigationController?.popViewController(animated: true)
    }
}
