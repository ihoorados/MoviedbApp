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

    init(client: HTTPClient) {
        
        self.client = client
    }
    
    func getMovies(query: String, page: Int) -> AnyPublisher<MoviesPage, Error> {
        
        let query = [URLQueryItem(name: "query", value: query), URLQueryItem(name: "page", value: String(page))]
        let provider = MovieProvider(queryForCall: query)
        guard let request = try? provider.makeRequest() else {
            return Fail(error: NetworkError.makeRequestFailed).eraseToAnyPublisher()
        }
        
        return client.publisher(request)
            .tryMap(MovieMapper.map)
            .eraseToAnyPublisher()
            
    }
}
