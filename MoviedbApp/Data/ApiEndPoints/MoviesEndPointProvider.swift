//
//  MoviesEndPointProvider.swift
//  MoviedbApp
//
//  Created by Hoorad on 1/14/25.
//

import Foundation

struct MovieProvider: Endpoint {
    
    init(queryForCall: [URLQueryItem]? = nil) {
        
        self.queryForCall = queryForCall
        self.path = "3/search/movie"
    }

    var baseURLString: String {
        return "https://api.themoviedb.org"
    }

    var path: String

    var headers: [String: String]? {

        return ["Content-Type": "application/json"]
    }

    var queryForCall: [URLQueryItem]?
    var params: [String: Any]? { return nil }
    var method: ApiHTTPMethod { return .GET }
    var customDataBody: Data? { return nil }
    
}
