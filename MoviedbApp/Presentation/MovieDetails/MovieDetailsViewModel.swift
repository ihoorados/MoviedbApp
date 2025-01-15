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
    
}
