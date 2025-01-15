//
//  MoviesSearchFlowCoordinator.swift
//  MoviedbApp
//
//  Created by Hoorad on 1/14/25.
//

import UIKit

protocol MoviesSearchCoordinator: AnyObject{}

final class MoviesSearchFlowCoordinator: MoviesSearchCoordinator{
    
    private weak var navigationController: UINavigationController?
    private weak var moviesQueriesSuggestionsVC: UIViewController?
    private weak var rootVC: MoviesListViewController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
        let remoteImageRepository = RemoteImageRepository()
        let remoteMoviesRepository = RemoteMoviesRepository()
        let useCase = SearchMoviesUseCaseFlow(repository: remoteMoviesRepository)
        let viewModel = MoviesListViewModel(coordinator: self, moviesUseCase: useCase)
        let vc = MoviesListViewController(viewModel: viewModel, imageRepository: remoteImageRepository)
        navigationController?.pushViewController(vc, animated: false)
        rootVC = vc
    }

}
