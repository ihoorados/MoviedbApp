//
//  MoviesRepository.swift
//  MoviedbApp
//
//  Created by Hoorad on 1/14/25.
//

import Combine
import Foundation

protocol MoviesRepository {

    func getMovies(query: String, page: Int) -> AnyPublisher<MoviesPage, Error>
}
