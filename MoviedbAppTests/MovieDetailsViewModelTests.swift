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

    private var subscribers = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    func testInitializationAndData() {
        
        // Arrange
        let movie = Movie(id: "1",
                          title: "Test Movie",
                          posterPath: "/path/to/image.jpg",
                          overview: "A great movie",
                          releaseDate: Date(),voteCount: 1,voteAvrage: 12)
        
        // Act
        let sut = MovieDetailsViewModel(movie: movie)

        // Assert
        XCTAssertEqual(sut.title, "Test Movie")
        XCTAssertEqual(sut.overview, "A great movie")
        XCTAssertNotNil(sut.releaseDate)
        XCTAssertEqual(sut.imagePath, "/path/to/image.jpg")
    }
    
    func testLoadImageSuccess() {
        
        // Arrange
        let movie = Movie(id: "1", title: "Test Movie", posterPath: "/path/to/image.jpg", overview: "A great movie", releaseDate: nil, voteCount: 1 , voteAvrage: 1)
        
        guard let sampleData = "testImageData".data(using: .utf8) else { return }
        let mockImageRepository = MockImageRepository()
        mockImageRepository.results = Result.success(sampleData).publisher.eraseToAnyPublisher()
        
        let sut = MovieDetailsViewModel(movie: movie, repository: mockImageRepository)


        let expectation = XCTestExpectation(description: "Expect image to be loaded successfully.")

        // Subscribe to image updates
        sut.$image
            .dropFirst() // Skip the initial nil value
            .sink { imageData in
                
                // Assert
                XCTAssertNotNil(imageData)
                XCTAssertEqual(imageData, sampleData)
                expectation.fulfill()
            }
            .store(in: &subscribers)

        // Act
        sut.loadImage(width: 500)

        // Wait for expectations
        wait(for: [expectation], timeout: 2.0)
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
