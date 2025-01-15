//
//  MoviesListViewController.swift
//  MoviedbApp
//
//  Created by Hoorad on 1/14/25.
//

import UIKit
import Combine

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
    
    // MARK: UI Properties

    private var subscriptions = Set<AnyCancellable>()

    private var tableViewLoadingSpinner: UIActivityIndicatorView?
    private lazy var searchController = UISearchController(searchResultsController: nil)
    
    static let reuseIdentifier = String(describing: MovieTableViewCell.self)
    private lazy var tableView: UITableView = {
        
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var centerMessageLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = .tertiaryLabel
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
    }()

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

typealias TableViewDataSourceAndDelegate = UITableViewDelegate & UITableViewDataSource

extension MoviesListViewController: TableViewDataSourceAndDelegate{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        self.viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Check for reusable cell
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: MoviesListViewController.reuseIdentifier, for: indexPath) as? MovieTableViewCell else{
            
            return UITableViewCell()
        }

        // Update current cell data
        cell.update(with: viewModel.items[indexPath.row], repository: imageRepository)

        // Check for update new page
        if indexPath.row == viewModel.items.count - 1 {
            self.viewModel.didLoadNext()
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.viewModel.didSelectItem(at: indexPath.row)
    }
}
