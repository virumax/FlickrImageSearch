//
//  Router.swift
//  Router
//
//  Created by Virendra Ravalji on 03/04/22.
//

import Foundation
import UIKit

typealias EntryPoint = View & UIViewController
protocol Router {
    var entry: EntryPoint? { get }
    static func start() -> Router
}

class ImageSearchRouter: Router {
    var entry: EntryPoint?
    
    static func start() -> Router {
        let router = ImageSearchRouter()
        
        var view: View = ImageSearchViewController()
        var presenter: Presenter = ImageSearchPresenter()
        var interactor: Interactor = ImageSearchInteractor()
        
        view.presenter = presenter
        interactor.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        router.entry = view as? EntryPoint
        
        return router
    }
}
