//
//  ApplicationDIContainer.swift
//  MoviedbApp
//
//  Created by Hoorad on 1/15/25.
//

import Foundation

final class ApplicationDIContainer {
    
    lazy var apiConfig = ApiConfig()
    
    lazy var authenticatedHTTPClientDecorator: HTTPClient = {
        
        let apiConfig = ApiConfig()
        return AuthenticatedHTTPClientDecorator(client: URLSession.shared, apiConfig: apiConfig)
    }()
    
    func makeMoviesSceneDIContainer() -> MovieViewDIContainer {
        let dependencies = MovieViewDIContainer.Dependencies(client: authenticatedHTTPClientDecorator)
        return MovieViewDIContainer(dependencies: dependencies)
    }
}
