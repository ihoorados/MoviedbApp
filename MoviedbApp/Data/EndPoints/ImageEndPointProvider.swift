//
//  ImageEndPointProvider.swift
//  MoviedbApp
//
//  Created by Hoorad on 1/14/25.
//

import Foundation

struct ImageProvider: Endpoint {

    init(imagePath: String, width: Int = 500) {
        
        self.path = "t/p/w\(width)" + imagePath
    }

    var baseURLString: String { return "https://image.tmdb.org" }

    var path: String

    var headers: [String: String]? {

        return ["Content-Type": "application/json"]
    }
    
    var method: ApiHTTPMethod { return .GET }
    var queryForCall: [URLQueryItem]? { return nil }
    var params: [String: Any]? { return nil }
    var customDataBody: Data? { return nil }
    
}
