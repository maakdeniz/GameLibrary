//
//  GamesPageViewController.swift
//  GameLibrary
//
//  Created by Mehmet Akdeniz on 12.07.2023.
//

import UIKit

final class GamesPageViewController: UIPageViewController {
    //MARK: - UIElements
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    //MARK: - Variables
    var viewModel: GamePageViewModelProtocol? {
        didSet {
            loadGameImage()
        }
    }
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
        
        loadGameImage()
    }
    //MARK: - Private Function
    func setupViewModel(_ viewModel: GamePageViewModelProtocol) {
        self.viewModel = viewModel
        loadGameImage()
    }
    
    private func loadGameImage() {
        if let imageUrl = viewModel?.gameImageURL {
            imageView.downloadImage(from: imageUrl)
        }
    }
    //MARK: - Objc Function
    @objc private func viewTapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        if imageView.frame.contains(location) {
            viewModel?.didSelectGame()
        }
    }
    
    @objc private func imageTapped(_ sender: UITapGestureRecognizer) {
        viewModel?.didSelectGame()
    }
}

