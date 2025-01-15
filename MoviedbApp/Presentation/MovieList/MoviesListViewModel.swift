//
//  MoviesListViewModel.swift
//  MoviedbApp
//
//  Created by Hoorad on 1/14/25.
//

final class MoviesListViewModel{
    
    
    // MARK: Dependency
    
    private let coordinator: MoviesSearchCoordinator
    private let moviesUseCase: SearchMoviesUseCase
    
    init(coordinator: MoviesSearchCoordinator, moviesUseCase: SearchMoviesUseCase) {
        
        self.coordinator = coordinator
        self.moviesUseCase = moviesUseCase
    }
    
    // MARK: State
    
    enum MoviesListViewModelState {
        
        case nextPage
        case loading
        case empty
        case result
        case none
    }
    
}
