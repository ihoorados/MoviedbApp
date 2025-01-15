//
//  MoviesResponseDTO.swift
//  MoviedbApp
//
//  Created by Hoorad on 1/14/25.
//

import Foundation

// MARK: - Movies Response Data Transfer Object
/// A Data Transfer Object (DTO) that represents the response structure for movie listings.
/// This DTO encapsulates all relevant information about movies returned from the API,
/// Data handling between the network layer and the application’s Domain.

struct MoviesResponseDTO: Decodable {
    
    let page: Int
    let totalPages: Int
    let movies: [MovieDTO]
    
    private enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case movies = "results"
    }
}

extension MoviesResponseDTO {
    
    struct MovieDTO: Decodable {
        
        let id: Int
        let title: String?
        let posterPath: String?
        let overview: String?
        let releaseDate: String?
        let voteCount: Int
        let voteAvrage: Double
        
        private enum CodingKeys: String, CodingKey {
            case id
            case title
            case posterPath = "poster_path"
            case overview
            case releaseDate = "release_date"
            case voteCount = "vote_count"
            case voteAvrage = "vote_average"
        }
    }
    
}
