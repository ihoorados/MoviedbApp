//
//  MovieCellViewModel.swift
//  MoviedbApp
//
//  Created by Hoorad on 1/15/25.
//

import Foundation

struct MovieCellViewModel{
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    let title: String
    let overview: String
    let releaseDate: String
    let imagePath: String?
    let id: String

    init(movie: Movie) {
        
        self.title = movie.title ?? ""
        self.imagePath = movie.posterPath
        self.overview = movie.overview ?? ""
        if let releaseDate = movie.releaseDate {
            self.releaseDate = dateFormatter.string(from: releaseDate)
        } else {
            self.releaseDate = "Release data not availble"
        }
        self.id = movie.id
    }
}
