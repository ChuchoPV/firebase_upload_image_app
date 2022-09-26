//
//  ViewController.swift
//  firebase_upload_app
//
//  Created by Jesús Perea (Mobile Engineer) on 25/09/22.
//

import UIKit
import FirebaseStorage

class MainViewController: UIViewController {
    
    var lblTitle = UILabel()
    var lblUploading = UILabel()
    var imgButton = UIImageView(image: nil)
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureDetector = UITapGestureRecognizer(target: self, action: #selector(didPressUpload))
        imgButton.addGestureRecognizer(gestureDetector)
        
        setup()
        setupContraints()
    }
    
    func setup() {
        view.backgroundColor = .white
        lblTitle.text = "Sube una imagen para continuar"
        lblTitle.textColor = .black
        lblTitle.textAlignment = .center
        
        lblUploading.text = "Subiendo imagen..."
        lblUploading.textAlignment = .center
        lblUploading.textColor = .black
        lblUploading.isHidden = true
        lblUploading.numberOfLines = 2
        
        imgButton.isUserInteractionEnabled = true
        imgButton.image = .init(named: "empty_image")
    }
    
    func setupContraints() {
        
        view.addSubview(lblTitle)
        view.addSubview(imgButton)
        view.addSubview(lblUploading)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        imgButton.translatesAutoresizingMaskIntoConstraints = false
        lblUploading.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            lblTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            lblTitle.heightAnchor.constraint(equalToConstant: 48),
            lblTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            lblUploading.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 16),
            lblUploading.heightAnchor.constraint(equalToConstant: 48),
            lblUploading.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            imgButton.topAnchor.constraint(equalTo: lblUploading.bottomAnchor, constant: 32),
            imgButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imgButton.heightAnchor.constraint(equalToConstant: 120),
            imgButton.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    @objc func didPressUpload() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        navigationController?.present(picker, animated: true)
    }
}

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage,
              let path = info[.imageURL] as? NSURL else {
            return
        }
        
        imgButton.image = image
        lblUploading.isHidden = false
        
        let imageName = path.path?.split(separator: "/").last?.description
        lblUploading.text = "Subiendo imagen..."
        upload(image: image, path: imageName)
    }
}

extension MainViewController {
    
    func upload(image: UIImage, path: String?) {
        
        guard let data = image.pngData(), let path = path else {
            lblUploading.text = "Hubo un error. Intenta nuevamente"
            return
        }
        
        let store = Storage.storage()
        let storeRef = store.reference()
        
        let ref = storeRef.child("image/\(path)")
        
        _ = ref.putData(data, metadata: nil) { [weak self] (metadata, error) in
            
            if let error = error as? NSError {
                
                let code = StorageErrorCode(rawValue: error.code)
                
                switch code {
                case .unauthorized:
                    self?.lblUploading.text = "Hubo un error. Intenta nuevamente\nArchivo muy grande"
                default:
                    self?.lblUploading.text = "Hubo un error. Intenta nuevamente\nError inesperado"
                }
                
                return
            }
            
            self?.lblUploading.text = "Carga correcta"
        }
    }
}
