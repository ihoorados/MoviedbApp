//
//  MovieDetailsViewModel.swift
//  MoviedbApp
//
//  Created by Hoorad on 1/15/25.
//

import Combine
import Foundation

final class MovieDetailsViewModel{
    
    private var repository: ImageRepository = RemoteImageRepository()
    private var cancellables: AnyCancellable?
    
    init(movie: Movie, repository: ImageRepository = RemoteImageRepository()) {
        
        self.title = movie.title ?? "No title"
        self.overview = movie.overview ?? "No Overview"
        if let releaseDate = movie.releaseDate {
            self.releaseDate = "Release Date : \(dateFormatter.string(from: releaseDate))"
        } else {
            self.releaseDate = "No Release Date"
        }
        self.imagePath = movie.posterPath
        self.repository = repository
        self.vote = "\(movie.voteCount) total vote with Avrage: \(movie.voteAvrage)"
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    private(set) var title: String
    private(set) var releaseDate: String
    private(set) var overview: String
    private(set) var imagePath: String?
    private(set) var vote: String
    
    @Published var image: Data? = nil
    
    private func updateImage(width: Int){
        
        guard let imagePath = self.imagePath else { return }
        
        if self.cancellables != nil { self.cancellables?.cancel() }
        
        self.cancellables = self.repository.getImageData(path: imagePath, width: width)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    // Image download completed successfully
                    break
                case .failure(let error):
                    // Handle download failure
                    print("Image download failed: \(error)")
                }
            }, receiveValue: { [weak self] imageData in
                // Process the downloaded image data
                self?.image = imageData
            })
        
    }
    
}

// MARK: ViewModel Input Trigger

extension MovieDetailsViewModel{
    
    func loadImage(width: Int){
        
        self.updateImage(width: width)
    }
}
