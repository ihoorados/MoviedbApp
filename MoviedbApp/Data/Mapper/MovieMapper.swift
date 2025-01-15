//
//  MovieMapper.swift
//  MoviedbApp
//
//  Created by Hoorad on 1/14/25.
//


import Foundation

/// A struct responsible for mapping JSON data received from a movie API into a model representation.
struct MovieMapper {
    
    struct InvalidJSONDecoder: Error {}

    /// Maps the received data and HTTP response to a `MoviesResponseDTO` instance.

    /// - Parameters:
    ///   - data: The raw data received from the API response, expected to be in a JSON format.
    ///   - response: The HTTP response received alongside the data, used to determine the success of the request.

    /// - Throws:
    ///   - `NetworkError.emptyErrorWithStatusCode`: If the response status code is not 200 or if decoding the JSON fails.

    /// - Returns: A `MoviesPage` instance if the mapping is successful.
    static func map(data: Data, response: HTTPURLResponse) throws -> MoviesPage {
        
        // Check if the response status code indicates success (200 OK).
        // If successful, attempt to decode the JSON data into a `MoviesResponseDTO`.
        if response.statusCode == 200, let movies = try? JSONDecoder().decode(MoviesResponseDTO.self, from: data) {
            // If decoding is successful, convert the `MoviesResponseDTO` into a `MoviesPage` and return it.
            return movies.makeMoviesPage()
        } else {
            // If the response is not successful, or decoding fails, throw a network error with the response status code.
            throw NetworkError.emptyErrorWithStatusCode(response.statusCode.description)
        }
    }
}

extension MoviesResponseDTO {
    
    func makeMoviesPage() -> MoviesPage {
        return .init(page: page, totalPages: totalPages, movies: movies.map { $0.makeMovie() })
    }
}

extension MoviesResponseDTO.MovieDTO {
    
    func makeMovie() -> Movie {
        
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            return formatter
        }()
        
        return .init(id: Movie.Identifier(id), title: title, posterPath: posterPath, overview: overview, releaseDate: dateFormatter.date(from: releaseDate ?? ""), voteCount: voteCount, voteAvrage: voteAvrage)
    }

}
