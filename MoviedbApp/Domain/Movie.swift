//
//  Movie.swift
//  MoviedbApp
//
//  Created by Hoorad on 1/14/25.
//

import Foundation

struct Movie: Equatable, Identifiable {
    
    typealias Identifier = String
    let id: Identifier
    let title: String?
    let posterPath: String?
    let overview: String?
    let releaseDate: Date?
    let voteCount: Int
    let voteAvrage: Double
}

struct MoviesPage: Equatable {
    
    let page: Int
    let totalPages: Int
    let movies: [Movie]
}
