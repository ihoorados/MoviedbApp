//
//  MoviesListViewModel.swift
//  MoviedbApp
//
//  Created by Hoorad on 1/14/25.
//

import Combine

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
    
    // MARK: Published Properties

    @Published var items: [Movie] = []
    @Published var state: MoviesListViewModelState = .none
    @Published var query: String = ""
    @Published var error: String = ""
    
    
    // MARK: Public Properties
    
    var screenTitle: String { return "Movies" }
    var centerTitle: String { return "Search results" }
    var errorTitle: String { return "Error" }
    var searchBarPlaceholder: String { return "Type something here to search" }
}
