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
    var photos: [Photo] { get set }
    var totalCount: Int { get }
    var currentCount: Int { get }
    
    func fetchData()
    func interactorDidFetchPhotos(with result: Result<Response, DataResponseError>)
}

class ImageSearchPresenter: Presenter {
    var router: Router?
    var interactor: Interactor?
    var view: View?
    var photos: [Photo] = []

    private var currentPage = 1
    private var total = 0
    private var isFetchInProgress = false
    
    var totalCount: Int {
      return total
    }
    
    var currentCount: Int {
      return photos.count
    }
    
    func fetchData() {
        guard !isFetchInProgress else {
          return
        }
        isFetchInProgress = true

        interactor?.getPhoto(page: currentPage, text: "Roses")
    }

    func interactorDidFetchPhotos(with result: Result<Response, DataResponseError>) {
        switch result {
        case .failure(let error):
            DispatchQueue.main.async { [weak self] in
                self?.isFetchInProgress = false
                self?.view?.update(with: error.localizedDescription)
            }
        case .success(let response):
            DispatchQueue.main.async { [weak self] in
                self?.currentPage += 1
                self?.isFetchInProgress = false
                // 2
                self?.total = response.photos.total
                self?.photos.append(contentsOf: response.photos.photo)
                
                if response.photos.page > 1 {
                    let indexPathsToReload = self?.calculateIndexPathsToReload(from: response.photos.photo)
                    self?.view?.update(with: indexPathsToReload)
                  } else {
                    self?.view?.update(with: .none)
                  }
            }
        }
    }

    private func calculateIndexPathsToReload(from newPhotos: [Photo]) -> [IndexPath] {
      let startIndex = photos.count - newPhotos.count
      let endIndex = startIndex + newPhotos.count
      return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
