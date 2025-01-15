//
//  ApplicationDIFactory.swift
//  MoviedbApp
//
//  Created by Hoorad on 1/15/25.
//

import Foundation

final class ApplicationDIFactory {
    
    static func create(coordinator: MoviesSearchCoordinator) -> MoviesListViewController {
        
        let remoteImageRepository = RemoteImageRepository()
        let client = makeAuthenticatedHTTPClientDecorator()
        let remoteMoviesRepository = RemoteMoviesRepository(client: client)
        let useCase = SearchMoviesUseCaseFlow(repository: remoteMoviesRepository)
        let viewModel = MoviesListViewModel(coordinator: coordinator, moviesUseCase: useCase)
        return MoviesListViewController(viewModel: viewModel, imageRepository: remoteImageRepository)
    }
    
    static func create(with movie: Movie) -> MovieDetailsViewController {
        
        let viewModel = MovieDetailsViewModel.init(movie: movie)
        let viewController = MovieDetailsViewController(viewModel: viewModel)
        return viewController
    }
    
    static func makeAuthenticatedHTTPClientDecorator() -> HTTPClient{
        
        let apiConfig = ApiConfig()
        return AuthenticatedHTTPClientDecorator(client: URLSession.shared, apiConfig: apiConfig)
    }
}
