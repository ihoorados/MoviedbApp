//
//  ApplicationDIFactory.swift
//  MoviedbApp
//
//  Created by Hoorad on 1/15/25.
//

final class ApplicationDIFactory {
    
    static func create(coordinator: MoviesSearchCoordinator) -> MoviesListViewController {
        
        let remoteImageRepository = RemoteImageRepository()
        let remoteMoviesRepository = RemoteMoviesRepository()
        let useCase = SearchMoviesUseCaseFlow(repository: remoteMoviesRepository)
        let viewModel = MoviesListViewModel(coordinator: coordinator, moviesUseCase: useCase)
        return MoviesListViewController(viewModel: viewModel, imageRepository: remoteImageRepository)
    }
}
