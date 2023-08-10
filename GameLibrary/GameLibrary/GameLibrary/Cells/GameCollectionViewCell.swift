//
//  GameCollectionViewCell.swift
//  GameLibrary
//
//  Created by Mehmet Akdeniz on 12.07.2023.
//

import UIKit
import GamesAPI // used for the data model

class GameCollectionViewCell: UICollectionViewCell {
    static let identifier = "GameCollectionViewCell"
    
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var gameRatingLabel: UILabel!
    @IBOutlet weak var gameYearLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.black
        self.contentView.layer.borderColor = UIColor.systemGray3.cgColor
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.shadowColor = UIColor.black.cgColor
        self.contentView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.contentView.layer.shadowRadius = 2.0
        self.contentView.layer.shadowOpacity = 0.5
        self.contentView.layer.masksToBounds = false
        
        gameImageView.layer.borderColor = UIColor.systemGray3.cgColor
        gameImageView.layer.borderWidth = 2
        gameImageView.layer.cornerRadius = 10
        gameImageView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        DispatchQueue.main.async { [weak self] in
            self?.gameImageView.image = UIImage(named: "loading")
        }
        gameTitleLabel.text = ""
        gameYearLabel.text = ""
        gameRatingLabel.text = ""
    }
    
    func configure(with game: Game) {
        gameTitleLabel.text = game.name
        if let rating = game.rating {
            gameRatingLabel.text = "\(rating)"
        } else {
            gameRatingLabel.text = "No rating"
        }
        gameYearLabel.text = "Released Date: " + (game.released ?? "No date")
        if let imageUrl = URL(string: game.backgroundImage ?? "") {
            gameImageView.downloadImage(from: imageUrl)
        }
    }
    
}
