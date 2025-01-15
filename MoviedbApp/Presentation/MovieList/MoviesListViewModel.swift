//
//  MoviesListViewModel.swift
//  MoviedbApp
//
//  Created by Hoorad on 1/14/25.
//

import Combine
import Foundation

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

    @Published var items: [MovieCellViewModel] = []
    @Published var state: MoviesListViewModelState = .none
    @Published var query: String = ""
    @Published var error: String = ""
    
    
    // MARK: Public Properties
    
    var screenTitle: String { return "Movies" }
    var centerTitle: String { return "Search results" }
    var errorTitle: String { return "Error" }
    var searchBarPlaceholder: String { return "Type something here to search" }
    
    var hasMorePages: Bool { currentPage < totalPageCount }
    var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }
    
    private(set) var currentPage: Int = 0
    private(set) var totalPageCount: Int = 1
    private(set) var moviesList: [MoviesPage] = []

    private var subscribers = Set<AnyCancellable>()

    // MARK: Private Functions
    
    /// Perform the movie fetching use case with the given query and page number.
    private func loadData(query: String, state: MoviesListViewModelState) {
        
        self.state = state
        self.query = query

        self.moviesUseCase.perform(query: query, page: nextPage)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                
                // Handle completion of the data fetch.
                switch completion {
                case .finished: break
                    // Successfully finished; no further action required in this case.
                case .failure(let error):
                    // Handle errors by calling a dedicated error handling method.
                    self?.onError(with: error)
                }
            }, receiveValue: { [weak self] result in

                if !result.movies.isEmpty{
                    
                    self?.state = .result
                }else{
                    
                    self?.state = .empty
                }
                
                // Update the movies list with the fetched data regardless of the count.
                self?.updateData(movies: result)

            })
            .store(in: &subscribers)
    }
    
    /// Updates the local movie data with the information from the provided `MoviesPage`.
    /// - Parameter movies: The `MoviesPage` instance containing the new data to update.
    private func updateData(movies: MoviesPage) {
        
        // Update the current page and total page count with the new movies data.
        self.currentPage = movies.page
        self.totalPageCount = movies.totalPages

        // Filter out any existing movie pages that match the incoming movie's page
        // and append the new `MoviesPage` to the movies list.
        self.moviesList = self.moviesList.filter { $0.page != movies.page } + [movies]
        
        // Flatten the list of movies extracted from all pages into a single array
        let allMovies = self.moviesList.flatMap { $0.movies }
        self.items = allMovies.map(MovieCellViewModel.init)

    }
    
    /// Handles errors that occur during data fetching or processing.
    /// - Parameter error: The error encountered, providing context for handling.
    private func onError(with error: Error) {
        
        // Reset the state to indicate no active operations are taking place.
        self.state = .none
        
        // Store the localized error message for potential UI display.
        self.error = error.localizedDescription
        
        // Additional error handling logic can be implemented here if needed.
        // For example, you can log error metrics.
    }
    
    /// and resetting relevant properties to their initial values.
    private func resetData() {
        
        // Cancel all active subscriptions to prevent unwanted callbacks.
        self.subscribers.forEach { $0.cancel() }
        
        // Reset the current page to 0 to indicate there are no pages loaded.
        self.currentPage = 0
        
        // Set the total page count to 1, indicating that no additional pages are available.
        self.totalPageCount = 1
        
        // Clear all movie entries from the movies list.
        self.moviesList.removeAll()
        
        // Clear all items in the items array, which may represent UI elements.
        self.items.removeAll()
        
        // Set the state to `.none`, indicating no active operations or data loading.
        self.state = .none
    }
}



// MARK: ViewModel Input Trigger

extension MoviesListViewModel{
    
    func didSearch(query: String){
        
        self.resetData()
        self.loadData(query: query, state: .loading)
    }
    
    func didSelectItem(at index: Int) {}
    
    func didLoadNext(){
        
        // Check for availble pages
        guard self.hasMorePages, self.state == .result else { return }
        self.loadData(query: self.query, state: .nextPage)
    }
    
    func didCancelSearch(){
        
        self.subscribers.forEach({ $0.cancel() })
        self.resetData()
    }
}
