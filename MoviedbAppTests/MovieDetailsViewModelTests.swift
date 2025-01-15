//
//  MovieDetailsViewModelTests.swift
//  MoviedbAppTests
//
//  Created by Hoorad on 1/15/25.
//

import XCTest
import Combine
@testable import MoviedbApp

final class MovieDetailsViewModelTests: XCTestCase {

    func testInitializationAndData() {
        
        // Arrange
        let movie = Movie(id: "1",
                          title: "Test Movie",
                          posterPath: "/path/to/image.jpg",
                          overview: "A great movie",
                          releaseDate: Date(),voteCount: 1,voteAvrage: 12)
        
        // Act
        let viewModel = MovieDetailsViewModel(movie: movie)

        // Assert
        XCTAssertEqual(viewModel.title, "Test Movie")
        XCTAssertEqual(viewModel.overview, "A great movie")
        XCTAssertNotNil(viewModel.releaseDate)
        XCTAssertEqual(viewModel.imagePath, "/path/to/image.jpg")
    }

}

// MARK: Mocks

class MockImageRepository: ImageRepository {
    
    // Array to hold multiple pages of movies to simulate various responses.
    var results: AnyPublisher<Data, Error>?

    func getImageData(path: String, width: Int) -> AnyPublisher<Data, Error> {

        guard let results = results else{
            return Fail(error: NSError()).eraseToAnyPublisher()
        }
        return results
    }
}
