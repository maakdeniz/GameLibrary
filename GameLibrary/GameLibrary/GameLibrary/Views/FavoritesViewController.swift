//
//  FavoritesViewController.swift
//  GameLibrary
//
//  Created by Mehmet Akdeniz on 14.07.2023.
//

import UIKit
import IndicatorVCExtension

final class FavoritesViewController: UIViewController{
    //MARK: - UIElements
    private var collectionView: UICollectionView?
    private var noFavoritesLabel: UILabel = {
        let label = UILabel()
        label.text = "There are no games in your favorites."
        label.textColor = .systemGray3
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    //MARK: - Variables
    private var viewModel: FavoritesViewModelProtocol = FavoritesViewModel()
    private var numberItemPerRow: CGFloat = 2
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        viewModel.startUpdating()
        collectionViewSetup()
        
        view.addSubview(noFavoritesLabel)
        NSLayoutConstraint.activate([
            noFavoritesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noFavoritesLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noFavoritesLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            noFavoritesLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
        ])
        
        updateNoFavoritesLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        itemPerRow()
        viewModel.startUpdating()
    }


    //MARK: - Override Function
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let width = (self.view.safeAreaLayoutGuide.layoutFrame.width - 24 - ((numberItemPerRow - 1) * 20)) / self.numberItemPerRow
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: width, height: width)
        }
        
        collectionView?.frame = view.bounds
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        itemPerRow()
    }
    //MARK: - Private function
    private func collectionViewSetup() {
    
        if collectionView == nil {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumInteritemSpacing = 20
            layout.minimumLineSpacing = 30
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            guard let collectionView = collectionView else {
                return
            }
            collectionView.register(FavoriteGameCollectionViewCell.self,
                                    forCellWithReuseIdentifier: FavoriteGameCollectionViewCell.identifier)
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.backgroundColor = UIColor(red: 21/255,
                                                     green: 23/255,
                                                     blue: 30/255,
                                                     alpha: 1)
            view.addSubview(collectionView)
        }
    }
    private func updateNoFavoritesLabel() {
        noFavoritesLabel.isHidden = !viewModel.isFavoritesEmpty()
    }
    
    private func itemPerRow() {
        guard let deviceOrientation = UIApplication.shared.currentUIWindow()?
            .windowScene?.interfaceOrientation else { return }
        if deviceOrientation.isLandscape {
            self.numberItemPerRow = 4
            
        } else {
            self.numberItemPerRow = 2
            
        }
    }
    
}
//MARK: - CollectionView Extension
extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.favoritesGameCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteGameCollectionViewCell.identifier, for: indexPath) as! FavoriteGameCollectionViewCell
        cell.configure(with: viewModel.getGameAt(indexPath.row))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let game = viewModel.getGameAt(indexPath.row)
        let gameDetailVC = storyboard?.instantiateViewController(withIdentifier: "GameDetailViewController") as! GameDetailViewController
        gameDetailVC.viewModel = GameDetailViewModel(gameId: game.id)
        gameDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(gameDetailVC, animated: true)
        
    }
}
//MARK: - FavoritesViewModel Extension
extension FavoritesViewController: FavoritesViewModelDelegate {
    func favoriteGamesDidUpdate() {
        collectionView?.reloadData()
        updateNoFavoritesLabel()
    }
}
