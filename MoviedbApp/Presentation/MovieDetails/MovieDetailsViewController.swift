//
//  MovieDetailsViewController.swift
//  MoviedbApp
//
//  Created by Hoorad on 1/15/25.
//

import UIKit
import Combine

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
    
    // MARK: UI Properties
    
    private let verticalStackView: UIStackView = {
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    private let movieImageView: UIImageView = {
       
        let imageView = UIImageView()
        return imageView
    }()
    
    private let titleLabel: UILabel = {
       
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let overViewTextView: UITextView = {
       
        let textView = UITextView()
        textView.textColor = .secondaryLabel
        textView.font = .systemFont(ofSize: 17, weight: .medium)
        return textView
    }()
    
    private let releaseDateLabel: UILabel = {
       
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    private let voteLabel: UILabel = {
       
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()

    private var subscriptions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: Private Functions

    private func setupUIView(){
        
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(self.verticalStackView)
        self.verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        self.verticalStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.verticalStackView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.verticalStackView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.verticalStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
        self.movieImageView.translatesAutoresizingMaskIntoConstraints = false
        self.movieImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        self.movieImageView.backgroundColor = .lightGray
        
        self.verticalStackView.addArrangedSubview(self.movieImageView)
        self.verticalStackView.addArrangedSubview(self.titleLabel)
        self.verticalStackView.addArrangedSubview(self.releaseDateLabel)
        self.verticalStackView.addArrangedSubview(self.voteLabel)
        self.verticalStackView.addArrangedSubview(self.overViewTextView)
    }
    
    private func updateData(with viewModel: MovieDetailsViewModel){
        
        self.titleLabel.text = viewModel.title
        self.releaseDateLabel.text = viewModel.releaseDate
        self.overViewTextView.text = viewModel.overview
        self.voteLabel.text = viewModel.vote
        // ImageView Place Holder
    }
    
    private func bind(to viewModel: MovieDetailsViewModel){
        
        viewModel.$image
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in

                guard let data = data else {                    
                    return
                }
                self?.movieImageView.image = UIImage(data: data)
            }
            .store(in: &subscriptions)
    }

}
