//
//  NetworkSession.swift
//  MoviedbApp
//
//  Created by Hoorad on 1/14/25.
//

import Foundation
import Combine

extension URLSession: HTTPClient{

    struct InvalidHTTPResponseError: Error {}

    func publisher(_ request: URLRequest) -> AnyPublisher<(Data, HTTPURLResponse), Error> {
        return dataTaskPublisher(for: request)
            .tryMap({ result in

                guard let httpResponse = result.response as? HTTPURLResponse else {

                    throw InvalidHTTPResponseError()
                }
                return (result.data, httpResponse)
            })
            .eraseToAnyPublisher()
    }
}
