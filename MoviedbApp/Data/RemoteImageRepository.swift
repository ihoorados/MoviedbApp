//
//  RemoteImageRepository.swift
//  MoviedbApp
//
//  Created by Hoorad on 1/14/25.
//

import Foundation
import Combine

protocol ImageRepository {

    func getImageData(path: String, width: Int) -> AnyPublisher<Data, Error>
}

final class RemoteImageRepository: ImageRepository {

    private var client: HTTPClient
    private var subscribers = Set<AnyCancellable>()
    private let backgroundQueue = DispatchQueue.global(qos: .userInitiated)

    init(client: HTTPClient = URLSession.shared) {
        
        self.client = client
    }
    
    func getImageData(path: String, width: Int) -> AnyPublisher<Data, Error> {
    
        let provider = ImageProvider(imagePath: path, width: width)
        return client.publisher(provider.makeRequest)
            .subscribe(on: backgroundQueue)
            .tryMap(ImageDownloadMapper.map)
            .eraseToAnyPublisher()
            
    }
}
