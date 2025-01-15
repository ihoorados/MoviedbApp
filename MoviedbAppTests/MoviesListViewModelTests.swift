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

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
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
