//
//  SearchMoviesUseCase.swift
//  MoviedbApp
//
//  Created by Hoorad on 1/14/25.
//

import Combine
import Foundation

protocol SearchMoviesUseCase {
    
    func perform(query: String, page: Int) -> AnyPublisher<MoviesPage, Error>
}

final class SearchMoviesUseCaseFlow: SearchMoviesUseCase{
    
    private let repository: MoviesRepository
    private let backgroundQueue = DispatchQueue.global(qos: .userInitiated)
    
    init(repository: MoviesRepository) {
        
        self.repository = repository
    }
    
    func perform(query: String, page: Int) -> AnyPublisher<MoviesPage, Error> {
        
        return repository.getMovies(query: query, page: page)
            .subscribe(on: backgroundQueue)
            .eraseToAnyPublisher()
    }
}
