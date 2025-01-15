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
        self.title = self.viewModel.screenTitle
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 200
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        self.tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
        
        self.centerMessageLabel.text = self.viewModel.centerTitle
        self.view.addSubview(self.centerMessageLabel)
        self.centerMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        self.centerMessageLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.centerMessageLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    private func reload() {
        
        tableView.reloadData()
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
