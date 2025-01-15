//
//  MovieDetailsViewController.swift
//  MoviedbApp
//
//  Created by Hoorad on 1/15/25.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    // MARK: Dependency
    
    private var viewModel: MovieDetailsViewModel
    
    init(viewModel: MovieDetailsViewModel) {
        
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboard are a pain")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
