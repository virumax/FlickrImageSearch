//
//  ImageSearchCollectionViewCell.swift
//  ImageSearchCollectionViewCell
//
//  Created by Virendra Ravalji on 03/04/22.
//

import UIKit

protocol ImageSearchCollectionViewCustomCell {
    var leftImageView: CustomImageView! { get set }
    var errorLabel: UILabel! { get set }
    func loadImage(for photo: Photo)
}

class ImageSearchCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: CustomImageView!
    @IBOutlet weak var errorLabel: UILabel!
    private var activityIndicator: UIActivityIndicatorView!
    let photoURLPlaceholder = "http://farm{farm}.static.flickr.com/{server}/{id}_{secret}.jpg"

    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator = UIActivityIndicatorView(style: .large)
        addSubview(activityIndicator)
        activityIndicator.center = imageView.center
        activityIndicator.startAnimating()
    }

    func loadImage(for photo: Photo) {
        activityIndicator.startAnimating()
        errorLabel.text = ""
        let photoURLString = "http://farm\(photo.farm).static.flickr.com/\(photo.server)/\(photo.id)_\(photo.secret).jpg"
        imageView.loadImage(for: photoURLString, completion: { [weak self] success in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.errorLabel.text = success ? "" : "Unable to fetch image"
            }
        })
    }
}

let cache = NSCache<AnyObject, UIImage>()
class CustomImageView: UIImageView {
    var imageURLString: String?
    func loadImage(for urlString: String, completion: @escaping (Bool) -> Void) {
        imageURLString = urlString
        image = nil
        if let image = cache.object(forKey: urlString as AnyObject) {
            self.image = image
            completion(true)
            return
        }
        
        if let photoURL = URL(string: urlString) {
            URLSession.shared.dataTask(with: photoURL) { [weak self] data, response, error in
                if let imageData = data, error == nil {
                    if let image = UIImage(data: imageData) {
                        cache.setObject(image, forKey: urlString as AnyObject)
                        DispatchQueue.main.async {
                            if self?.imageURLString == urlString {
                                self?.image = image
                            }
                            completion(true)
                        }
                    }
                } else {
                    completion(false)
                }
            }.resume()
        }
    }
}
