//
//  ImageStorage.swift
//  MoviedbApp
//
//  Created by Hoorad on 1/16/25.
//

import Foundation
import Combine

protocol ImagesStorage {
    
    func fetch(for urlPath: String) -> AnyPublisher<Data, Error>
    func save(imageData: Data, for urlPath: String)
}
