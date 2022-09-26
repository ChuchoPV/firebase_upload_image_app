//
//  ImageViewerViewController.swift
//  firebase_upload_app
//
//  Created by Jesús Perea (Mobile Engineer) on 25/09/22.
//

import UIKit
import FirebaseStorage

extension NSCollectionLayoutSection {
    
    static func list(sectionInsets: NSDirectionalEdgeInsets = .init(),
                     itemInsets: NSDirectionalEdgeInsets = .init(),
                     itemHeight: NSCollectionLayoutDimension? = nil,
                     itemWidth: NSCollectionLayoutDimension? = nil,
                     height: NSCollectionLayoutDimension = .estimated(100),
                     horizontalLayoutItems: Int = 1) -> NSCollectionLayoutSection {
        
        // MARK: Item Size
        let horizontalLayoutFraction = 1 / CGFloat(horizontalLayoutItems)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: itemWidth ?? .fractionalWidth(horizontalLayoutFraction),
                                              heightDimension: itemHeight ?? height)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = itemInsets
        
        // MARK: Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: height)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // MARK: Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = sectionInsets
        
        return section
    }
}

class ImageViewerViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(UINib(nibName: cellName, bundle: Bundle(for: ImageViewerCellCollectionViewCell.self)), forCellWithReuseIdentifier: cellName)
            collectionView.dataSource = self
        }
    }
    
    let cellName = String(describing: ImageViewerCellCollectionViewCell.self)
    var isLoading = true
    var images: [URL?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        download()
    }
}

extension ImageViewerViewController: UICollectionViewDataSource {
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath) as! ImageViewerCellCollectionViewCell
        cell.configure(image: images[indexPath.row])
        return cell
    }
}

extension ImageViewerViewController {
    
    func download() {
        let store = Storage.storage()
        let storeRef = store.reference()
        
        let ref = storeRef.child("image")
        
        ref.listAll { [weak self] (result, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            guard let items = result?.items else {
                print("Error al mostrar")
                return
            }
            
            for item in items {
                item.downloadURL { [weak self] url, error in
                    
                    if let error = error {
                        print(error)
                        return
                    }
                    
                    self?.images.append(url)
                    self?.collectionView.reloadData()
                }
            }
        }
    }
}
