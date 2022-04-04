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
    
    func update(with newIndexPathsToReload: [IndexPath]?)
    func update(with error: String)
}

class ImageSearchViewController: UIViewController, View {
    var presenter: Presenter?
    let cellMargin = 8
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var indicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        presenter?.fetchData()
        
        indicatorView.color = .lightGray
        indicatorView.startAnimating()
    }

    // MARK: Private methods
    private func setupCollectionView() {
        let nib = UINib(nibName: "ImageSearchCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ImageSearchCustomCell")
        collectionView.isHidden = true
        collectionView.reloadData()
        
        collectionView.prefetchDataSource = self
    }

    func update(with newIndexPathsToReload: [IndexPath]?) {
        indicatorView.stopAnimating()
        indicatorView.isHidden = true
        guard let newIndexPathsToReload = newIndexPathsToReload else {
          collectionView.isHidden = false
          collectionView.reloadData()
          return
        }

        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        collectionView.reloadItems(at: indexPathsToReload)
    }

    func update(with error: String) {
        indicatorView.stopAnimating()
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
        
        if isLoadingCell(for: indexPath) {
            cell.loadImage(for: .none)
        } else {
            cell.loadImage(for: presenter?.photos[indexPath.item])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.totalCount ?? 0
    }
}

extension ImageSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let space: CGFloat = CGFloat(cellMargin * 4)
        let size:CGFloat = (collectionView.frame.size.width - space) / 3.0
        return CGSize(width: size, height: size)
    }
}

extension ImageSearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            presenter?.fetchData()
        }
    }
}

private extension ImageSearchViewController {
  func isLoadingCell(for indexPath: IndexPath) -> Bool {
    return indexPath.row >= (presenter?.currentCount ?? 0)
  }
  
  func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
    let indexPathsForVisibleItems = collectionView.indexPathsForVisibleItems
    let indexPathsIntersection = Set(indexPathsForVisibleItems).intersection(indexPaths)
    return Array(indexPathsIntersection)
  }
}
