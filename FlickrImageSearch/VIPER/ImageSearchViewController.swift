//
//  ImageSearchViewController.swift
//  ImageSearchViewController
//
//  Created by Virendra Ravalji on 03/04/22.
//

import UIKit

// ViewController
// Protocol
// Ref to Presenter

protocol View {
    var presenter: Presenter? { get set }
    
    func update(with photo: Response)
    func update(with error: String)
}

class ImageSearchViewController: UIViewController, View {
    var presenter: Presenter?
    let cellMargin = 8
    var photos = [Photo]()
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        collectionView.reloadData()
        presenter?.fetchData()
    }

    // MARK: Private methods
    private func setupCollectionView() {
        let nib = UINib(nibName: "ImageSearchCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ImageSearchCustomCell")
        collectionView.isHidden = true
    }

    func update(with response: Response) {
        photos = response.photos.photo
        collectionView.isHidden = false
        collectionView.reloadData()
    }

    func update(with error: String) {
        collectionView.reloadData()
        collectionView.isHidden = true
        
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension ImageSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageSearchCustomCell", for: indexPath) as! ImageSearchCollectionViewCell
        
        cell.imageView.backgroundColor = .lightGray
        
        let photo = photos[indexPath.item]
        cell.loadImage(for: photo)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
}

extension ImageSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let space: CGFloat = CGFloat(cellMargin * 4)
        let size:CGFloat = (collectionView.frame.size.width - space) / 3.0
        return CGSize(width: size, height: size)
    }
}
