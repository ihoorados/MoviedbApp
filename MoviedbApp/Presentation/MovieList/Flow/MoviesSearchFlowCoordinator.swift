//
//  MoviesSearchFlowCoordinator.swift
//  MoviedbApp
//
//  Created by Hoorad on 1/14/25.
//

import UIKit

final class MoviesSearchFlowCoordinator{
    
    private let dependencies: MoviesSearchFlowCoordinatorDependencies
    private weak var rootVC: MoviesListViewController?
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController, dependencies: MoviesSearchFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        
        let callBackAction = MoviesListViewModelCallBack(onShowMovieDetails: onShowMovieDetails(movie:))
        let vc = dependencies.makeMoviesListViewController(callBack: callBackAction)
        navigationController?.pushViewController(vc, animated: false)
        rootVC = vc
    }
    
    func onShowMovieDetails(movie: Movie){
        
        // In case want to navigation to SwiftUIView
        // let vc = dependencies.makeMoviesDetailsSwiftUIView(movie: movie)
        
        let vc = dependencies.makeMoviesDetailsViewController(movie: movie)
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
