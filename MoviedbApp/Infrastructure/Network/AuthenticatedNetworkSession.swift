//
//  AuthenticatedNetworkSession.swift
//  MoviedbApp
//
//  Created by Hoorad on 1/14/25.
//

import Combine
import Foundation


class AuthenticatedHTTPClientDecorator: HTTPClient{

    private let apiConfig: ApiConfig
    private let client: HTTPClient

    init(client: HTTPClient, apiConfig: ApiConfig = ApiConfig()) {
        self.client = client
        self.apiConfig = apiConfig
    }

    func publisher(_ request: URLRequest) -> AnyPublisher<(Data, HTTPURLResponse), Error> {

        let apiKey = apiConfig.apiKey
        var signRequest = request
        signRequest.allHTTPHeaderFields?.removeValue(forKey: "Authorization")
        signRequest.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        return client.publisher(signRequest)
            .eraseToAnyPublisher()
    }
}
