//
//  EndPoint.swift
//  MoviedbApp
//
//  Created by Hoorad on 1/14/25.
//

import Foundation

protocol Endpoint {
    
    var baseURLString: String { get }
    var path: String { get }
    var headers: [String: String]? { get }
    var queryForCall: [URLQueryItem]? { get }
    var params: [String: Any]? { get }
    var method: ApiHTTPMethod { get }
    var customDataBody: Data? { get }
}

enum ApiHTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
    case PATCH
}
