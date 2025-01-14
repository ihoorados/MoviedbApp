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

extension Endpoint {
    
    var makeRequest: URLRequest {
        
        var urlComponents = URLComponents(string: baseURLString)
        var longPath = baseURLString.last != "/" ? "/" : ""
        
        longPath.append(path)
        urlComponents?.path = longPath

        if let queryForCalls = queryForCall {
            urlComponents?.queryItems = [URLQueryItem]()
            for queryForCall in queryForCalls {
                urlComponents?.queryItems?.append(URLQueryItem(name: queryForCall.name, value: queryForCall.value))
            }
        }

        guard let url = urlComponents?.url else { return URLRequest(url: URL(string: baseURLString)!) }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        if let headers = headers {
            for header in headers {
                request.addValue(header.value, forHTTPHeaderField: header.key)
            }
        }
        
        if let params = params {

            let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
            request.httpBody = jsonData
        }

        if let customDataBody = customDataBody {
            request.httpBody = customDataBody
        }
        return request
    }

   
}
