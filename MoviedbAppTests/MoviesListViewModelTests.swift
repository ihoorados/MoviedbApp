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

    private var subscribers = Set<AnyCancellable>()
    
    let moviePages = {
        
        let initialPage = MoviesPage(page: 1, totalPages: 2, movies: [Movie(id: "1", title: "Test Movie 1", posterPath: nil, overview: nil, releaseDate: nil, voteCount: 22, voteAvrage: 6.5)])
        let nextMoviesPage = MoviesPage(page: 2, totalPages: 2, movies: [Movie(id: "2", title: "Test Movie 2", posterPath: nil, overview: nil, releaseDate: nil, voteCount: 1, voteAvrage: 12)])
        return [initialPage, nextMoviesPage]
    }()

    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        
        super.tearDown()
    }
    
    func testWhenSearchMoviesUseCaseRecivedEmptyMovies() {
        
        // Arrange
        let coordinatorMock = MoviesSearchCoordinatorMock()
        let moviesUseCaseMock = MoviesUseCaseMock()
        let expectedMoviesPage = MoviesPage(page: 1, totalPages: 1, movies: [])
        moviesUseCaseMock.results = Just(expectedMoviesPage).setFailureType(to: Error.self).eraseToAnyPublisher()
        
        let sut = MoviesListViewModel(coordinator: coordinatorMock, moviesUseCase: moviesUseCaseMock)
        
        // Create an expectation for the empty state after search
        let expectation = XCTestExpectation(description: "Expect empty state after searching for movies.")

        // Act When
        sut.didSearch(query: "Test") // Initiate the search

        // Subscribe to items to assess the state after calling didSearch
        sut.$items
            .dropFirst() // Skip the initial value
            .sink { items in
                // Then Assert
                XCTAssertEqual(sut.state, .empty) // Ensure empty state
                XCTAssertEqual(items.count, 0) // Check that we have zero items now
                XCTAssertFalse(sut.hasMorePages) // Check that we have no more pages
                XCTAssertEqual(sut.currentPage, 1) // Check current page
                
                // Fulfill the expectation
                expectation.fulfill()
            }
            .store(in: &subscribers)

        // Wait for expectations
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testWhenSearchMoviesUseCaseRecivedMoviesAndUpdatesStateAndItems() {
        
        // Arrange
        let coordinatorMock = MoviesSearchCoordinatorMock()
        let moviesUseCaseMock = MoviesUseCaseMock()
        let expectedMoviesPage = MoviesPage(page: 1, totalPages: 1, movies: [Movie(id: "1", title: "Test Movie", posterPath: nil, overview: nil, releaseDate: nil, voteCount: 22, voteAvrage: 6.5)])
        moviesUseCaseMock.results = CurrentValueSubject(expectedMoviesPage).eraseToAnyPublisher()
        let sut = MoviesListViewModel(coordinator: coordinatorMock, moviesUseCase: moviesUseCaseMock)

        // Act
        sut.didSearch(query: "Test") // Initiate the search

        // Create expectation to wait for initial items to be updated
        let initialExpectation = XCTestExpectation(description: "Expect initial movies to be loaded.")
        
        // Subscribe to items to assess the state after calling didSearch
        sut.$items
            .dropFirst() // Skip the initial state
            .sink(receiveCompletion: { complition in
                
            }, receiveValue: { items in
                
                // Assert
                XCTAssertEqual(sut.state, .result) // Ensure no loading state
                XCTAssertEqual(items.count, 1) // Check that we have one item now
                XCTAssertEqual(items.first?.title, "Test Movie") // Check that the item is as expected
                XCTAssertEqual(items.first?.voteCount, 22) // Check that the vote is as expected
                initialExpectation.fulfill() // Fulfill the expectation after validation
            })
            .store(in: &subscribers) // Store reference to prevent deallocation
        
        // Wait for the expectation for the next page to be fulfilled
        wait(for: [initialExpectation], timeout: 1.0)
    }
    
    func testWhenUseCaseStartAndUpdateLoadingStateAndResetData() {
        
        // Arrange
        let coordinatorMock = MoviesSearchCoordinatorMock()
        let moviesUseCaseMock = MoviesUseCaseMock()
        let expectedMoviesPage = MoviesPage(page: 1, totalPages: 1, movies: [Movie(id: "1", title: "Test Movie", posterPath: nil, overview: nil, releaseDate: nil, voteCount: 22, voteAvrage: 6.5)])
        moviesUseCaseMock.results = CurrentValueSubject(expectedMoviesPage).eraseToAnyPublisher()
        let sut = MoviesListViewModel(coordinator: coordinatorMock, moviesUseCase: moviesUseCaseMock)
        
        // Act
        sut.didSearch(query: "Test") // Initiate the search
        
        XCTAssertEqual(sut.state, .loading) // Ensure loading state
        XCTAssertTrue(sut.items.isEmpty) // Check that we have zero item now
    }
    
    func testDidLoadNextPageAndLoadMoreMovies() {
        
        // Arrange
        let coordinatorMock = MoviesSearchCoordinatorMock()
        let moviesUseCaseMock = MoviesUseCaseMock()
        moviesUseCaseMock.results = Result.success(moviePages[0]).publisher.eraseToAnyPublisher()
        let sut = MoviesListViewModel(coordinator: coordinatorMock, moviesUseCase: moviesUseCaseMock)
            
        // Create expectation to wait for initial items to be updated
        let initialExpectation = XCTestExpectation(description: "Expect initial movies to be loaded.")
        
        sut.didSearch(query: "Test") // Initiate first load

        // Subscribe to changes to items
        sut.$items
            .dropFirst() // Skip the initial value (empty)
            .sink { items in
                initialExpectation.fulfill() // Fulfill the expectation after validation
            }
            .store(in: &subscribers)
        
        // Wait for the expectation to be fulfilled
        wait(for: [initialExpectation], timeout: 1.0)
        
        XCTAssertTrue(sut.hasMorePages)

        // Now we set up for loading the next page
        moviesUseCaseMock.results = Just(moviePages[1]).setFailureType(to: Error.self).eraseToAnyPublisher()

        // Act: Trigger loading the next page
        sut.didLoadNext()
        
        // Create expectation to wait for the next items to be updated
        let nextPageExpectation = XCTestExpectation(description: "Expect more movies to be loaded.")
        
        // Subscribe to changes to items for the next page
        sut.$items
            .dropFirst(1) // Skip the initial (first load) and the loading state
            .sink { items in
                // Assert - Ensure that items count is as expected
                XCTAssertEqual(items.count, 2)
                XCTAssertEqual(items.first?.title, "Test Movie 1")
                XCTAssertEqual(items.last?.title, "Test Movie 2")
                nextPageExpectation.fulfill() // Fulfill the expectation after validation
            }
            .store(in: &subscribers)
        
        // Wait for the expectation for the next page to be fulfilled
        wait(for: [nextPageExpectation], timeout: 2.0)
    }
    
    func testWhenSearchMoviesUseCaseRecivedError() {
        
        // Arrange
        let coordinatorMock = MoviesSearchCoordinatorMock()
        let moviesUseCaseMock = MoviesUseCaseMock()
        moviesUseCaseMock.results = Fail(error: NSError(domain: "Network error", code: 1, userInfo: [NSLocalizedDescriptionKey: "Network error"]) ).eraseToAnyPublisher() // Simulate an error
        
        let sut = MoviesListViewModel(coordinator: coordinatorMock, moviesUseCase: moviesUseCaseMock)
        
        // Create an expectation for the error handling after search
        let expectation = XCTestExpectation(description: "Expect error handling after searching for movies.")
        
        // Act When
        sut.didSearch(query: "Test") // Initiate the search

        // Subscribe to items to assess the state after calling didSearch
        sut.$error
            .dropFirst() // Skip the initial value
            .sink { error in
                
                // Then Assert
                XCTAssertEqual(sut.state, .none) // Ensure empty state
                XCTAssertEqual(error, "Network error")
                
                // Fulfill the expectation
                expectation.fulfill()
            }
            .store(in: &subscribers)

        // Wait for expectations
        wait(for: [expectation], timeout: 1.0)
    }
    

}

// MARK: - Mocks

/// A mock implementation of the `SearchMoviesUseCase` protocol for testing purposes.
class MoviesUseCaseMock: SearchMoviesUseCase {
    
    // Array to hold multiple pages of movies to simulate various responses.
    var results: AnyPublisher<MoviesPage, Error>?

    /// Performs a movie search using the given query and page number.
    /// - Parameters:
    ///   - query: The search query string.
    ///   - page: The page number to fetch (1-based index).
    /// - Returns: A publisher that emits the corresponding `MoviesPage` or an error.
    func perform(query: String, page: Int) -> AnyPublisher<MoviesPage, Error> {
        
        guard let results = results else{
            return Fail(error: NSError()).eraseToAnyPublisher()
        }
        return results
    }
}

class MoviesSearchCoordinatorMock: MoviesSearchCoordinator {}
