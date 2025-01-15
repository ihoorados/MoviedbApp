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

    
    // MARK: - Private Function

    private func fetchRequest(for pathUrl: String) -> NSFetchRequest<ImageEntity> {

        let request: NSFetchRequest = ImageEntity.fetchRequest()
        request.predicate = NSPredicate(format: "%K = %@", #keyPath(ImageEntity.pathUrl), pathUrl)
        return request
    }
    
    private func deleteImage(for urlPath: String, in context: NSManagedObjectContext) {
        
        let request = fetchRequest(for: urlPath)
        do {
            if let result = try context.fetch(request).first {
                context.delete(result)
            }
        } catch {
            print(error)
        }
    }
    
    static func removeLeastRecentlyUsedImages() {
        
        CoreDataStorage.shared.performBackgroundTask { context in
            
            do {
                let fetchRequest: NSFetchRequest = ImageEntity.fetchRequest()
                
                let sort = NSSortDescriptor(key: #keyPath(ImageEntity.lastUsedAt), ascending: false)
                fetchRequest.sortDescriptors = [sort]
                
                let entities = try context.fetch(fetchRequest)
                
                var totalSizeUsed = 0
                entities.forEach { entity in
                    totalSizeUsed += (entity.data as? NSData)?.length ?? 0
                    print(totalSizeUsed)
                    if totalSizeUsed > self.maxSizeInBytes {
                        context.delete(entity)
                    }
                }

                try context.save()
            } catch {
                assertionFailure("CoreDataStorage Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }

}

extension CoreDataImagesStorage: ImagesStorage {
    
    func fetch(for urlPath: String) -> AnyPublisher<Data, Error> {
        
        return Future<Data, Error> { [weak self] promise in
            self?.coreDataStorage.performBackgroundTask { context in
                
                guard let self = self else { return }
                do {
                    let fetchRequest = self.fetchRequest(for: urlPath)
                    let entity = try context.fetch(fetchRequest).first
                    
                    // Update the last used date
                    entity?.lastUsedAt = self.currentTime()
                    
                    // Save the context
                    try context.save()
                    
                    // Ensure entity's data exists and send success
                    if let data = entity?.data {
                        
                        promise(.success(data)) // Emit data on success
                    } else {
                        
                        let error = NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Network error"])
                        // Emit an error if data is nil
                        promise(.failure(CoreDataStorageError.readError(error)))
                    }
                } catch {
                    
                    // Emit error on failure
                    promise(.failure(CoreDataStorageError.readError(error)))
                }
            }
        }
        .eraseToAnyPublisher() // Convert to AnyPublisher<Data, Error>
    }
    
    func save(imageData: Data, for urlPath: String) {
        
        coreDataStorage.performBackgroundTask { context in
            do {
                
                self.deleteImage(for: urlPath, in: context)
                
                let entity: ImageEntity = .init(context: context)
                entity.data = imageData
                entity.pathUrl = urlPath
                entity.lastUsedAt = self.currentTime()
                
                try context.save()
                
            } catch {
                assertionFailure("CoreDataUsersStorage Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }
    
}
