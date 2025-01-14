//
//  RemoteMoviesRepository.swift
//  MoviedbApp
//
//  Created by Hoorad on 1/14/25.
//

import Combine
import Foundation

final class RemoteMoviesRepository: MoviesRepository {

    private var client: HTTPClient
    private var subscribers = Set<AnyCancellable>()
    private let backgroundQueue = DispatchQueue.global(qos: .userInitiated)

    init(client: HTTPClient = AuthenticatedHTTPClientDecorator(client: URLSession.shared)) {
        
        self.client = client
    }
    
    func getMovies(query: String, page: Int) -> AnyPublisher<MoviesPage, Error> {
        
        let query = [URLQueryItem(name: "query", value: query), URLQueryItem(name: "page", value: String(page))]
        let provider = MovieProvider(queryForCall: query)
        return client.publisher(provider.makeRequest)
            .tryMap(MovieMapper.map)
            .eraseToAnyPublisher()
            
    }
}
