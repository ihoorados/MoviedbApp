//
//  EndPointTest.swift
//  MoviedbApp
//
//  Created by Hoorad on 1/17/25.
//

import XCTest
import Foundation
@testable import MoviedbApp

class EndpointTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testValidRequest() {
        
        let endpoint = MockEndpoint(baseURLString: "https://api.example.com", path: "images", method: .GET)
        let request = try? endpoint.makeRequest()
        
        XCTAssertNotNil(request)
        XCTAssertEqual(request?.url?.absoluteString, "https://api.example.com/images")
        XCTAssertEqual(request?.httpMethod, "GET")
    }

    func testEmptyBaseURL() {
        
        let endpoint = MockEndpoint(baseURLString: "", path: "images")
        XCTAssertThrowsError(try endpoint.makeRequest()) { error in
            
            guard let error = error as? NetworkError, let errorDescription = error.errorDescription else{
                return
            }
            XCTAssertEqual(errorDescription, "Invalid url") // Check for expected error description
        }
    }

    func testInvalidBaseURL() {
        
        let endpoint = MockEndpoint(baseURLString: "invalid_url", path: "images")
        XCTAssertThrowsError(try endpoint.makeRequest()) { error in
            
            guard let error = error as? NetworkError, let errorDescription = error.errorDescription else{
                return
            }
            XCTAssertEqual(errorDescription, "Invalid url") // Check for expected error description
        }
    }

    func testPathNoLeadingSlash() {
        
        let endpoint = MockEndpoint(baseURLString: "https://api.example.com", path: "images")
        let request = try? endpoint.makeRequest()
        
        XCTAssertNotNil(request)
        XCTAssertEqual(request?.url?.absoluteString, "https://api.example.com/images")
    }

    func testPathWithLeadingSlash() {
        
        let endpoint = MockEndpoint(baseURLString: "https://api.example.com/", path: "images")
        let request = try? endpoint.makeRequest()

        XCTAssertNotNil(request)
        XCTAssertEqual(request?.url?.absoluteString, "https://api.example.com/images") // Should still be valid
    }

    func testQueryParametersWithNilValue() {
        
        let queryItems = [URLQueryItem(name: "key", value: "value"), URLQueryItem(name: "anotherKey", value: nil)]
        let endpoint = MockEndpoint(baseURLString: "https://api.example.com", path: "search", queryForCall: queryItems)
        let request = try? endpoint.makeRequest()

        XCTAssertNotNil(request)
        // Only valid query parameter should be included
        XCTAssertEqual(request?.url?.absoluteString, "https://api.example.com/search?key=value")
    }

    func testCustomDataBody() {
        
        let body = "{\"key\":\"value\"}".data(using: .utf8)!
        let endpoint = MockEndpoint(baseURLString: "https://api.example.com", path: "post", method: .POST, customDataBody: body)
        let request = try? endpoint.makeRequest()

        XCTAssertNotNil(request)
        XCTAssertEqual(request?.httpBody, body)
        XCTAssertEqual(request?.httpMethod, "POST")
    }

    func testParamsSerialization() {
        
        let params = ["key": "value"]
        let endpoint = MockEndpoint(baseURLString: "https://api.example.com", path: "post", params: params, method: .POST)
        let request = try? endpoint.makeRequest()

        XCTAssertNotNil(request)
        if let httpBody = request?.httpBody {
            let json = try? JSONSerialization.jsonObject(with: httpBody, options: [])
            XCTAssertNotNil(json)
            XCTAssertEqual((json as? [String: Any])?["key"] as? String, "value")
        }
    }

    func testHeadersHandling() {
        
        let headers = ["Authorization": "Bearer token"]
        let endpoint = MockEndpoint(baseURLString: "https://api.example.com", path: "images", headers: headers)
        let request = try? endpoint.makeRequest()
        
        XCTAssertNotNil(request)
        XCTAssertEqual(request?.allHTTPHeaderFields?["Authorization"], "Bearer token")
    }
    
}

// MARK: Mocks

class MockEndpoint: Endpoint {
    
    var baseURLString: String
    var path: String
    var headers: [String: String]?
    var queryForCall: [URLQueryItem]?
    var params: [String: Any]?
    var method: ApiHTTPMethod
    var customDataBody: Data?

    init(baseURLString: String, path: String, headers: [String: String]? = nil, queryForCall: [URLQueryItem]? = nil, params: [String: Any]? = nil, method: ApiHTTPMethod = .GET, customDataBody: Data? = nil) {
        self.baseURLString = baseURLString
        self.path = path
        self.headers = headers
        self.queryForCall = queryForCall
        self.params = params
        self.method = method
        self.customDataBody = customDataBody
    }
}
