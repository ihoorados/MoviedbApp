//
//  MoviesListViewModelTests.swift
//  MoviedbAppTests
//
//  Created by Hoorad on 1/15/25.
//

import XCTest
import Combine
@testable import MoviedbApp

final class MoviesListViewModelTests: XCTestCase {

    var viewModel: MoviesListViewModel!
    var moviesUseCaseMock: MoviesUseCaseMock!
    var coordinatorMock: MoviesSearchCoordinatorMock!
    private var subscribers = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        
        self.coordinatorMock = MoviesSearchCoordinatorMock()
        self.moviesUseCaseMock = MoviesUseCaseMock()
        self.viewModel = MoviesListViewModel(coordinator: coordinatorMock, moviesUseCase: moviesUseCaseMock)
    }
    
    override func tearDown() {
        
        self.viewModel = nil
        self.moviesUseCaseMock = nil
        self.coordinatorMock = nil
        super.tearDown()
    }
    
    func testWhenSearchMoviesUseCaseRecivedEmptyMovies() {
        
        // Arrange
        let expectedMoviesPage = MoviesPage(page: 1, totalPages: 1, movies: [])
        moviesUseCaseMock.results = [expectedMoviesPage]

        // Act When
        viewModel.didSearch(query: "Test") // Initiate the search
        
        // Subscribe to items to assess the state after calling didSearch
        viewModel.$items
            .dropFirst()
            .sink { [weak self] item in
                
                guard let self = self else { return }
                
                // Then Assert
                XCTAssertEqual(self.viewModel.state, .empty) // Ensure empty state
                XCTAssertEqual(self.viewModel.items.count, 0) // Check that we have zero item now
                XCTAssertFalse(self.viewModel.hasMorePages) // Check that we have no more page
                XCTAssertEqual(self.viewModel.currentPage, 1) // Check current page
            }
            .store(in: &subscribers)
    }
    
    func testWhenSearchMoviesUseCaseRecivedMoviesAndUpdatesStateAndItems() {
        
        // Arrange
        let expectedMoviesPage = MoviesPage(page: 1, totalPages: 1, movies: [Movie(id: "1", title: "Test Movie", posterPath: nil, overview: nil, releaseDate: nil, voteCount: 22, voteAvrage: 6.5)])
        moviesUseCaseMock.results = [expectedMoviesPage]
        
        // Act
        viewModel.didSearch(query: "Test") // Initiate the search

        // Subscribe to items to assess the state after calling didSearch
        viewModel.$items
            .dropFirst() // Skip the initial state
            .sink { [weak self] items in
                
                guard let self = self else { return }
                
                // Assert
                XCTAssertEqual(self.viewModel.state, .result) // Ensure no loading state
                XCTAssertEqual(items.count, 1) // Check that we have one item now
                XCTAssertEqual(items.first?.title, "Test Movie") // Check that the item is as expected
                XCTAssertEqual(items.first?.voteCount, 22) // Check that the vote is as expected
            }
            .store(in: &subscribers) // Store reference to prevent deallocation
    }
    
    func testWhenUseCaseStartAndUpdateLoadingStateAndResetData() {
        
        // Arrange
        let expectedMoviesPage = MoviesPage(page: 1, totalPages: 1, movies: [Movie(id: "1", title: "Test Movie", posterPath: nil, overview: nil, releaseDate: nil, voteCount: 22, voteAvrage: 6.5)])
        moviesUseCaseMock.results = [expectedMoviesPage]
        
        // Act
        viewModel.didSearch(query: "Test") // Initiate the search
        
        XCTAssertEqual(self.viewModel.state, .loading) // Ensure loading state
        XCTAssertTrue(viewModel.items.isEmpty) // Check that we have zero item now
    }

}

// MARK: - Mocks

/// A mock implementation of the `SearchMoviesUseCase` protocol for testing purposes.
class MoviesUseCaseMock: SearchMoviesUseCase {
    
    // Array to hold multiple pages of movies to simulate various responses.
    var results: [MoviesPage] = []
    
    // An optional error to return for simulating failure scenarios.
    var errorToReturn: Error?

    /// Performs a movie search using the given query and page number.
    /// - Parameters:
    ///   - query: The search query string.
    ///   - page: The page number to fetch (1-based index).
    /// - Returns: A publisher that emits the corresponding `MoviesPage` or an error.
    func perform(query: String, page: Int) -> AnyPublisher<MoviesPage, Error> {
        if let error = errorToReturn {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        // Check the validity of the page number requested.
        guard page > 0, page <= results.count else {
            // Return a failure publisher for an invalid page request.
            return Fail(error: NSError(domain: "InvalidPageError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Requested page is out of range."]))
                .eraseToAnyPublisher()
        }
        
        // Return the corresponding movies page using page-1 for zero-based indexing.
        return Just(results[page - 1])
            .setFailureType(to: Error.self) // Set the failure type for the publisher.
            .eraseToAnyPublisher() // Erase to a generic publisher type.
    }
}

class MoviesSearchCoordinatorMock: MoviesSearchCoordinator {}
