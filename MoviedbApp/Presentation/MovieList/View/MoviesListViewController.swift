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

    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupUIView()
        self.setupSearchController()
        self.bind(to: self.viewModel)
    }
    

    // MARK: Private Functions
    
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
    
    private func setupSearchController() {
        
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = self.viewModel.searchBarPlaceholder
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.delegate = self
        self.navigationItem.searchController = self.searchController
    }
    
    private func reload() {
        
        tableView.reloadData()
    }
    
    private func setupLoadingController(){
        
        self.tableViewLoadingSpinner?.removeFromSuperview()
        self.tableViewLoadingSpinner = self.makeActivityIndicator(size: .init(width: self.view.frame.width, height: 44), style: .large)
        self.view.addSubview(self.tableViewLoadingSpinner!)
        self.tableViewLoadingSpinner?.translatesAutoresizingMaskIntoConstraints = false
        self.tableViewLoadingSpinner?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
        self.tableViewLoadingSpinner?.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0.0).isActive = true
    }
    
    // MARK: Binding
    
    private func bind(to viewModel: MoviesListViewModel){
        
        viewModel.$items
           .receive(on: DispatchQueue.main)
           .sink { [weak self] items in
               self?.tableView.reloadData()
           }
           .store(in: &subscriptions)
        
        viewModel.$query
            .receive(on: DispatchQueue.main)
            .sink { [weak self] query in
                
                self?.searchController.isActive = false
                self?.searchController.searchBar.text = query
            }
            .store(in: &subscriptions)
        
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                
                switch state{
                    
                case .nextPage:
                    
                    guard let self = self else { return }
                    self.tableViewLoadingSpinner?.removeFromSuperview()
                    self.tableViewLoadingSpinner = makeActivityIndicator(size: .init(width: self.tableView.frame.width, height: 44), style: .medium)
                    self.tableView.tableFooterView = tableViewLoadingSpinner

                case .loading:
                    
                    self?.setupLoadingController()
                    self?.centerMessageLabel.isHidden = true

                case .empty:
                    
                    self?.tableViewLoadingSpinner?.removeFromSuperview()
                    self?.centerMessageLabel.text = "Empty result"
                    self?.centerMessageLabel.isHidden = false
                    // Show Empty Result
                    
                case .result:
                    
                    self?.tableView.tableFooterView = nil
                    self?.tableViewLoadingSpinner?.removeFromSuperview()
                    self?.centerMessageLabel.isHidden = true
                    
                case .none:
                    
                    self?.tableView.tableFooterView = nil
                    self?.tableViewLoadingSpinner?.removeFromSuperview()
                    self?.centerMessageLabel.text = "Search result"
                    guard let isEmptyItem = self?.viewModel.items.isEmpty else{
                        return
                    }
                    self?.centerMessageLabel.isHidden = !isEmptyItem
                }
            }
            .store(in: &subscriptions)
        
        viewModel.$error
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                
                self?.setupAlert(message: error)
            }
            .store(in: &subscriptions)
        
    }

    func setupAlert(title: String = "Error", message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        UIView.animate(withDuration: 0.2) {
            cell.transform = CGAffineTransform.identity
        }
    }
}



extension MoviesListViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else { return }
        searchController.isActive = false
        self.viewModel.didSearch(query: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        self.searchController.isActive = false
        self.viewModel.didSearch(query: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.viewModel.didCancelSearch()
    }
}
