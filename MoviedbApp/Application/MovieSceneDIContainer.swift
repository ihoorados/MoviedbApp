//
//  MovieSceneDIContainer.swift
//  MoviedbApp
//
//  Created by Hoorad on 1/15/25.
//

import UIKit

// Protocol to define the dependencies required for the Movies Search Flow Coordinator
protocol MoviesSearchFlowCoordinatorDependencies {
    func makeMoviesListViewController(callBack: MoviesListViewModelCallBack) -> MoviesListViewController
    func makeMoviesDetailsViewController(movie: Movie) -> UIViewController
}

// Dependency Injection Container for managing the creation of movie-related components
final class MovieViewDIContainer: MoviesSearchFlowCoordinatorDependencies {
    
    // Structure to hold common dependencies needed by the container, such as HTTPClient
    struct Dependencies {
        let client: HTTPClient
    }
    
    private let dependencies: Dependencies

    // Initializer to set up the container with required dependencies
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Use Cases

    func makeSearchMoviesUseCase() -> SearchMoviesUseCase {
        return SearchMoviesUseCaseFlow(repository: makeMoviesRepository())
    }
    
    // MARK: - Repositories

    func makeMoviesRepository() -> MoviesRepository {
        return RemoteMoviesRepository(client: dependencies.client)
    }
    
    func makeRemoteImagesRepository() -> ImageRepository {
        return RemoteImageRepository()
    }
    
    // MARK: - Movies List

    // Function to create an instance of MoviesListViewController
    func makeMoviesListViewController(callBack: MoviesListViewModelCallBack) -> MoviesListViewController {
        
        return MoviesListViewController(viewModel: makeMoviesListViewModel(callBack: callBack), imageRepository: makeRemoteImagesRepository())
    }
    
    func makeMoviesListViewModel(callBack: MoviesListViewModelCallBack) -> MoviesListViewModel {
        return MoviesListViewModel(callBack: callBack, moviesUseCase: makeSearchMoviesUseCase())
    }
    
    // MARK: - Movie Details

    func makeMoviesDetailsViewController(movie: Movie) -> UIViewController {
        return MovieDetailsViewController(viewModel: makeMoviesDetailsViewModel(movie: movie))
    }
    
    func makeMoviesDetailsViewModel(movie: Movie) -> MovieDetailsViewModel {
        return MovieDetailsViewModel(movie: movie)
    }

    // MARK: - Flow Coordinators

    func makeMoviesSearchFlowCoordinator(navigationController: UINavigationController) -> MoviesSearchFlowCoordinator {
        return MoviesSearchFlowCoordinator(navigationController: navigationController, dependencies: self)
    }
}
