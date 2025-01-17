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
    
    func makeRequest() throws -> URLRequest {
        
        guard self.isValidUrl(url: self.baseURLString) else {
            
            debugPrint("Error creating URL from baseURLString: \(String(describing: baseURLString))")
            throw NetworkError.invalidURL
            //throw NSError(domain: "Invalid url", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid url"])
        }
        
        let sanitizedPath = !baseURLString.hasSuffix("/") ? "/" + path : path
        var urlComponents = URLComponents(string: baseURLString+sanitizedPath)

        // Set query items safely
        if let queryForCalls = queryForCall, !queryForCalls.isEmpty {
            urlComponents?.queryItems = queryForCalls.filter { $0.value != nil && !$0.value!.isEmpty }
        }
        
        guard let url = urlComponents?.url else {
            
            debugPrint("Error creating URL from components: \(String(describing: urlComponents))")
            throw NetworkError.invalidURL
            //throw NSError(domain: "Invalid url", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid url"])
        }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // Add headers safely
        headers?.forEach { request.addValue($1, forHTTPHeaderField: $0) }

        // Prepare httpBody only if data is provided
        if let customDataBody = customDataBody {
            request.httpBody = customDataBody
        } else if let params = params {
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        }
        
        return request
    }


    func isValidUrl(url: String) -> Bool {
        let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: url)
        return result
    }
   
}
