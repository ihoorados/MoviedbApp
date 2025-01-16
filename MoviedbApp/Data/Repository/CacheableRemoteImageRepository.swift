//
//  CacheableRemoteImageRepository.swift
//  MoviedbApp
//
//  Created by Hoorad on 1/16/25.
//

import Combine
import Foundation

final class CacheableRemoteImageRepository: ImageRepository {

    private var client: HTTPClient
    private let imagesCache: ImagesStorage
    private var subscribers = Set<AnyCancellable>()
    private let backgroundQueue = DispatchQueue.global(qos: .userInitiated)

    init(client: HTTPClient = URLSession.shared, imageCache: ImagesStorage) {
        
        self.imagesCache = imageCache
        self.client = client
    }
    
    func getImageData(path: String, width: Int) -> AnyPublisher<Data, Error> {
        
        return imagesCache.fetch(for: path)
            .catch { _ in
                
                let provider = ImageProvider(imagePath: path, width: width)
                return self.client.publisher(provider.makeRequest)
                    .subscribe(on: self.backgroundQueue)
                    .tryMap { response in
                        
                        // Map the response to the image data
                        let imageData = response.0
                        // Save the fetched data to cache
                        self.imagesCache.save(imageData: imageData, for: path)
                        return imageData
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
