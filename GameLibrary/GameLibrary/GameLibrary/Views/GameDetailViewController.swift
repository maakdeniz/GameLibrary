//
//  GameDetailViewController.swift
//  GameLibrary
//
//  Created by Mehmet Akdeniz on 12.07.2023.
//

import UIKit
import IndicatorVCExtension

final class GameDetailViewController: UIViewController, GameDetailViewModelDelegate {
    
    var viewModel: GameDetailViewModelProtocol! {
        didSet {
            viewModel.delegate = self
            viewModel.fetchGameDetails()
            showActivityIndicator()
            isFavorite = viewModel.isGameFavorite()
        }
    }
    
    //MARK: - UIElements
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var metacriticRateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    lazy var favoriteButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "heart"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(favoriteButtonTapped))
        return button
    }()
    
    
    //MARK: - Variables
    var isFavorite: Bool = false {
        didSet {
            if isFavorite {
                favoriteButton.image = UIImage(systemName: "trash")
            } else {
                favoriteButton.image = UIImage(systemName: "heart")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameImage.layer.cornerRadius = 10
        navigationItem.rightBarButtonItem = favoriteButton
        
    }
    //MARK: - Functions
    @objc func favoriteButtonTapped() {
        viewModel.toggleFavoriteStatus()
    }
    
    func gameDetailDidFetch() {
        DispatchQueue.main.async { [weak self] in
            self?.updateUI()
        }
        
    }
    
    func gameFavoriteStatusDidChange() {
        isFavorite = viewModel.isGameFavorite()
    }
    
    func updateUI() {
        
        nameLabel.text = viewModel.gameTitle
        releaseDateLabel.text = viewModel.gameReleaseDate
        metacriticRateLabel.text = viewModel.metacriticRateTitle
        descriptionLabel.text = viewModel.gameDescription
        if let imageUrl = URL(string: viewModel.gameImageUrl ?? "") {
            gameImage.downloadImage(from: imageUrl)
        }
        hideActivityIndicator()
    }
}
