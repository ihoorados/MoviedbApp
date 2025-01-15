//
//  MoviesListViewController.swift
//  MoviedbApp
//
//  Created by Hoorad on 1/14/25.
//

import UIKit

class MoviesListViewController: UIViewController {
        
    // MARK: Dependency
    
    private var viewModel: MoviesListViewModel
    private var imageRepository: ImageRepository

    init(viewModel: MoviesListViewModel, imageRepository: ImageRepository) {
        
        self.viewModel = viewModel
        self.imageRepository = imageRepository
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboard are a pain")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupUIView()
    }
    

    private func setupUIView(){
        
        self.view.backgroundColor = .systemBackground
        self.title = "Search Movie"
    }

}
