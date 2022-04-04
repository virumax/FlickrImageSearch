//
//  Presenter.swift
//  Presenter
//
//  Created by Virendra Ravalji on 03/04/22.
//

import Foundation

// Object
// Protocol
// ref to View, Interactor, Router

protocol Presenter {
    var router: Router? { get set }
    var interactor: Interactor? { get set }
    var view: View? { get set }
    
    func fetchData()
    func interactorDidFetchPhotos(with result: Result<Response, DataResponseError>)
}

class ImageSearchPresenter: Presenter {
    var router: Router?
    
    var interactor: Interactor?
    
    var view: View?
    
    func fetchData() {
        interactor?.getPhoto()
    }

    func interactorDidFetchPhotos(with result: Result<Response, DataResponseError>) {
        switch result {
        case .failure(let error):
            DispatchQueue.main.async { [weak self] in
                self?.view?.update(with: error.localizedDescription)
            }
        case .success(let response):
            DispatchQueue.main.async { [weak self] in
                self?.view?.update(with: response)
            }
        }
    }
}
