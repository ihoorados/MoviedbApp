//
//  ImageDownloadMapper.swift
//  MoviedbApp
//
//  Created by Hoorad on 1/14/25.
//

import Foundation

/// A utility struct for mapping and handling image download responses from the network.

/// The `ImageDownloadMapper` provides the functionality to validate HTTP responses
/// and return the appropriate data. It checks the response status code, and if the
/// status code indicates a successful request (200 OK), it returns the downloaded data.
/// If the response indicates an error, it throws a `NetworkError` with the corresponding
/// status code.

/// - Throws:
///   - `NetworkError.emptyErrorWithStatusCode` if the response status code is not 200.
struct ImageDownloadMapper {
    
    struct InvalidJSONDecoder: Error {}

    static func map(data: Data, response: HTTPURLResponse) throws -> Data {
        
        if response.statusCode == 200 {
            return data
        } else {
            throw NetworkError.emptyErrorWithStatusCode(response.statusCode.description)
        }
    }
}
