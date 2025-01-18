//
//  MovieDetailsSwiftUIView.swift
//  MoviedbApp
//
//  Created by Hoorad on 1/18/25.
//

import SwiftUI
import Combine

struct MovieDetailsSwiftUIView: View {
    
    @ObservedObject var viewModel: MovieDetailsSwiftUIViewModel
    
    var body: some View {
        
        ScrollView {
         
            VStack {
                
                // Display the image
                viewModel.image?
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 200)
                    .cornerRadius(10)
                    .padding()
                
                // Movie Information
                Text(self.viewModel.viewModel.title)
                    .font(.headline)
                    .padding(.top, 8)

                Text(viewModel.viewModel.releaseDate)
                    .font(.subheadline)
                    .padding(.bottom, 4)
                
                Text(self.viewModel.viewModel.overview)
                    .font(.body)
                    .padding()
                    .multilineTextAlignment(.center)
                
                Text(self.viewModel.viewModel.vote)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .padding()
            .onAppear {
                
                self.viewModel.viewModel.loadImage(width: 500)
            }
            
        }
    }
}

#Preview {
    
    let movie = Movie(id: "1",
                      title: "Test Movie",
                      posterPath: "/7WsyChQLEftFiDOVTGkv3hFpyyt.jpg",
                      overview: "When a dedicated rescue worker inadvertently gets caught up in the kidnapping plot of a mogul's tween daughter, he must save her from the clutches of rival gangs hunting them down with unpredictable dangers around every corner.",
                      releaseDate: Date(),voteCount: 1,voteAvrage: 12)
    let repository = RemoteImageRepository()
    let viewModel = MovieDetailsViewModel(movie: movie, repository: repository)
    let wrappedViewModel = MovieDetailsSwiftUIViewModel(viewModel: viewModel)
    MovieDetailsSwiftUIView(viewModel: wrappedViewModel)
}
