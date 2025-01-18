//
//  MovieDetailsSwiftUIViewModel.swift
//  MoviedbApp
//
//  Created by Hoorad on 1/18/25.
//

import Combine
import Foundation
import SwiftUI

@available(iOS 13.0, *)
final class MovieDetailsSwiftUIViewModel: ObservableObject {
    
    var viewModel: MovieDetailsViewModel
    @Published var image: Image? = Image("placeholder") // Default placeholder image
    private var subscribers = Set<AnyCancellable>()

    init(viewModel: MovieDetailsViewModel) {
        
        self.viewModel = viewModel
        viewModel.$image
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { data in
                
                guard let data = data, let image = UIImage(data: data) else { return }
                self.image = Image(uiImage: image)
            })
            .store(in: &subscribers)
    }
}
