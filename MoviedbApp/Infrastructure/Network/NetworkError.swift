//
//  NetworkError.swift
//  MoviedbApp
//
//  Created by Hoorad on 1/14/25.
//

enum NetworkError: Error {
    
    case requestFailed
    case normalError(Error)
    case apiKeyExpired
    case emptyErrorWithStatusCode(String)

    var errorDescription: String? {
        switch self {
        case .requestFailed:
            return "Request Failed"
        case .normalError(let error):
            return error.localizedDescription
        case .apiKeyExpired:
            return "Token Expired"
        case .emptyErrorWithStatusCode(let status):
            return status
        }
    }
}
