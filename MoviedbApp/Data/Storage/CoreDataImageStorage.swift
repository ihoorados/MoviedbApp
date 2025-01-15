//
//  CoreDataImageStorage.swift
//  MoviedbApp
//
//  Created by Hoorad on 1/16/25.
//


import Foundation
import CoreData
import Combine

final class CoreDataImagesStorage {
    
    // MARK: - Dependency
    
    static let maxSizeInBytes = 20 * 1000000 // 20 MB

    private let coreDataStorage: CoreDataStorage
    private let currentTime: () -> Date
    
    init(coreDataStorage: CoreDataStorage = .shared, currentTime: @escaping () -> Date) {
        
        self.coreDataStorage = coreDataStorage
        self.currentTime = currentTime
    }

}
