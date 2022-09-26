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
    var btnImages = UIButton()
    
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
        
        let btnImagesGesture = UITapGestureRecognizer(target: self, action: #selector(didPressImages))
        btnImages.addGestureRecognizer(btnImagesGesture)
        
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
        
        btnImages.setTitle("Ver Imágenes", for: .normal)
        btnImages.backgroundColor = .blue
        
    }
    
    func setupContraints() {
        
        view.addSubview(lblTitle)
        view.addSubview(imgButton)
        view.addSubview(lblUploading)
        view.addSubview(btnImages)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        imgButton.translatesAutoresizingMaskIntoConstraints = false
        lblUploading.translatesAutoresizingMaskIntoConstraints = false
        btnImages.translatesAutoresizingMaskIntoConstraints = false
        
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
            imgButton.widthAnchor.constraint(equalToConstant: 150),
            
            btnImages.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 24),
            btnImages.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btnImages.heightAnchor.constraint(equalToConstant: 48),
            btnImages.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    @objc func didPressUpload() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        navigationController?.present(picker, animated: true)
    }
    
    @objc func didPressImages() {
        
        let viewer = ImageViewerViewController()
        navigationController?.pushViewController(viewer, animated: true)
    }
}

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage, let path = info[.imageURL] as? NSURL else {
            return
        }
        
        imgButton.image = image
        let imageName = path.path?.split(separator: "/").last?.description
        
        let confimrScreen = ConfirmScreenViewController(image: image, path: imageName, confirmDelegate: self)
        navigationController?.pushViewController(confimrScreen, animated: true)
    }
}

extension MainViewController: ConfirmDelegate {
    func didConfirm(image: UIImage, path: String?) {
        lblUploading.isHidden = false
        lblUploading.text = "Subiendo imagen..."
        upload(image: image, path: path)
    }
    
    func didCancel() {
        imgButton.image = .init(named: "empty_image")
    }
    
    
    func upload(image: UIImage, path: String?) {
        
        guard let data = image.pngData(), let path = path else {
            lblUploading.text = "Hubo un error. Intenta nuevamente"
            return
        }
        
        let store = Storage.storage()
        let storeRef = store.reference()
        
        let ref = storeRef.child("image/\(path)")
        
        _ = ref.putData(data, metadata: nil) { [weak self] (_, error) in
            
            if let error = error as? NSError {
                
                let code = StorageErrorCode(rawValue: error.code)
                
                switch code {
                case .unauthorized:
                    self?.lblUploading.text = "Hubo un error. Intenta nuevamente\nArchivo muy grande"
                default:
                    self?.lblUploading.text = "Hubo un error. Intenta nuevamente\nError desconocido"
                }
            } else {
                self?.lblUploading.text = "Carga completada correctamente"
            }
        }
    }
}
