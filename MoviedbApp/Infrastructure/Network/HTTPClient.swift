//
//  HTTPClient.swift
//  MoviedbApp
//
//  Created by Hoorad on 1/14/25.
//

import Foundation
import Combine

protocol HTTPClient {
    func publisher(_ request: URLRequest) -> AnyPublisher<(Data, HTTPURLResponse), Error>
}
