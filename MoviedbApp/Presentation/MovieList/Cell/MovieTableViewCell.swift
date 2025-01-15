//
//  MovieTableViewCell.swift
//  MoviedbApp
//
//  Created by Hoorad on 1/15/25.
//

import UIKit
import Combine

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var movieOverViewLabel: UILabel!
    @IBOutlet weak var movieDateLabel: UILabel!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    
    var repository: ImageRepository?
    
    private var cancellables: AnyCancellable?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(with viewModel: MovieCellViewModel, repository: ImageRepository){
        
        self.movieTitleLabel.text = viewModel.title
        self.movieDateLabel.text = viewModel.releaseDate
        self.movieOverViewLabel.text = viewModel.overview
        
        self.repository = repository
        self.movieImageView.image = nil
        guard let path = viewModel.imagePath else { return }
        self.updateImage(path: path, with: 72)
    }
    
    func updateImage(path: String, with: Int){
        
        if self.cancellables != nil{
            
            cancellables?.cancel()
        }
        
        self.cancellables = self.repository?.getImageData(path: path, width: with)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    
                    // Image download completed successfully
                    break
                case .failure(let error):
                    
                    // Handle download failure
                    debugPrint("Image download failed: \(error)")
                }
            }, receiveValue: { [weak self] imageData in
                
                // Process the downloaded image data
                self?.movieImageView?.image = UIImage(data: imageData)
            })
        
    }
    
}
