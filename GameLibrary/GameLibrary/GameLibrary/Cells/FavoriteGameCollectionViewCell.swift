//
//  FavoriteGameCollectionViewCell.swift
//  GameLibrary
//
//  Created by Mehmet Akdeniz on 14.07.2023.
//FavoriteGameCollectionViewCell

import UIKit
import GamesAPI // user for the data model

class FavoriteGameCollectionViewCell: UICollectionViewCell {
    static let identifier = "FavoriteGameCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .systemGray3
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        resetImage()
        self.contentView.layer.backgroundColor = UIColor(red: 35, green: 37, blue: 43, alpha: 1).cgColor
        self.contentView.backgroundColor = .clear
        self.contentView.layer.borderWidth = 0
        self.contentView.layer.borderColor = UIColor.black.cgColor
        self.imageView.layer.cornerRadius = 10.0
        self.imageView.layer.masksToBounds = true
        self.imageView.clipsToBounds = true
        self.backgroundColor = .clear
        setAutoLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetImage()
    }
    
    func resetImage() {
        DispatchQueue.main.async { [weak self] in
            self?.imageView.image = UIImage(named: "loading")
        }
    }
    
    private func setAutoLayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor,constant: -8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
 
    func configure(with model: Game) {
        self.nameLabel.text = model.name
        if let url = URL(string: model.backgroundImage!) {
            self.imageView.downloadImage(from: url)
        }
    }
}



