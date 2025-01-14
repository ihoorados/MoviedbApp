//
//  MoviesListViewController.swift
//  MoviedbApp
//
//  Created by Hoorad on 1/14/25.
//

import UIKit

class MoviesListViewController: UIViewController {

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
