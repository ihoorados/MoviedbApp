//
//  ApiConfig.swift
//  MoviedbApp
//
//  Created by Hoorad on 1/14/25.
//

import Foundation

final class ApiConfig {
    
    lazy var accessTokenAuth: String = {
        
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "accessTokenAuth") as? String else {
            fatalError("ApiKey must not be empty in plist")
        }
        return apiKey
    }()
}
