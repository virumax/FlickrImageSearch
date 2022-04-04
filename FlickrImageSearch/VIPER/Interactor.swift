//
//  Interactor.swift
//  Interactor
//
//  Created by Virendra Ravalji on 03/04/22.
//

import Foundation

// Object
// Protocol
// Ref to Interactor

protocol Interactor {
    var presenter: Presenter? { get set }
    var service: ImageSearchClient { get set }
    
    func getPhoto()
}

class ImageSearchInteractor: Interactor {
    var presenter: Presenter?
    var service = ImageSearchClient()
    func getPhoto() {
        service.sendRequest(nil, parameters: ["text": "Kittens"]) { [weak self] responseObject, error in
            guard let responseObject = responseObject, error == nil else {
                self?.presenter?.interactorDidFetchPhotos(with: Result.failure(error!))
                return
            }
            self?.presenter?.interactorDidFetchPhotos(with: Result.success(responseObject))
        }
    }
}
