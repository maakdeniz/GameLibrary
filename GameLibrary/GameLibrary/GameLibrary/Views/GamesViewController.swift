//
//  GamesViewController.swift
//  GameLibrary
//
//  Created by Mehmet Akdeniz on 12.07.2023.
//

import UIKit
import IndicatorVCExtension

final class GamesViewController: UIViewController {
    
    //MARK: - UIElements
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var gamesCollectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    var gamesPageViewController: UIPageViewController?
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.text = "No games found"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .systemGray3
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    //MARK: - Variables
    private var topRatedGameVCs: [UIViewController] = []
    var viewModel: GamesViewModelProtocol = GamesViewModel()
    let collectionViewLayout = UICollectionViewFlowLayout()
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        UIConfigure()
        configure()
        configureViewModel()
        collectionViewRegister()
        view.addSubview(noResultsLabel)
        noResultsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noResultsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noResultsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noResultsLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            noResultsLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
        ])
        NotificationCenter.default.addObserver(self, selector: #selector(gameSelected(_:)),
                                               name: .didSelectGame, object: nil)
    }
    
    //MARK: - Override function
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        gamesCollectionView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PageViewSegue", let pageVC = segue.destination as? UIPageViewController {
            self.gamesPageViewController = pageVC
            self.gamesPageViewController?.delegate = self
            self.gamesPageViewController?.dataSource = self

            DispatchQueue.main.async { [weak self] in
                if let firstVC = self?.topRatedGameVCs.first {
                    self?.gamesPageViewController?.setViewControllers([firstVC], direction: .forward, animated: true)
                }
            }
        }
    }
    
    //MARK: - Private function
    private func UIConfigure() {
        collectionViewLayout.sectionInset = .init(top: 0,
                                                  left: 10,
                                                  bottom: 0,
                                                  right: 10)
        gamesCollectionView.setCollectionViewLayout(collectionViewLayout, animated: true)
        containerView.layer.backgroundColor = UIColor(red: 21, green: 23, blue: 30, alpha: 1).cgColor
        containerView.layer.cornerRadius = 10
        searchBar.searchTextField.textColor = .systemGray3
        let placeholder = NSAttributedString(string: "Search Games ...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
            searchBar.searchTextField.attributedPlaceholder = placeholder
    }
    
    private func configure() {
        searchBar.delegate = self
        gamesCollectionView.delegate = self
        gamesCollectionView.dataSource = self
        pageControl.numberOfPages = topRatedGameVCs.count
    }
    
    private func collectionViewRegister() {
        let nib = UINib(nibName: "GameCollectionViewCell", bundle: nil)
        self.gamesCollectionView.register(nib, forCellWithReuseIdentifier: "GameCollectionViewCell")
    }
    
    private func configureViewModel() {
        viewModel.delegate = self
        viewModel.fetchTopRatedGames()
        showActivityIndicator()
        viewModel.fetchGames()
    }
    
    private func setupTopRatedGameVCs() {
        topRatedGameVCs = viewModel.topRatedGames.compactMap { game -> UIViewController? in
            let gameViewModel = GamePageViewModel(game: game)
            
            if let vc = storyboard?.instantiateViewController(withIdentifier: "GamesPageViewController") as? GamesPageViewController {
                vc.setupViewModel(gameViewModel)
                return vc
            }
            return nil
        }
        pageControl.numberOfPages = topRatedGameVCs.count
        if let firstVC = topRatedGameVCs.first {
            self.gamesPageViewController?.setViewControllers([firstVC], direction: .forward, animated: true)
        }
    }
    //MARK: - OBJC function
    @objc private func gameSelected(_ notification: Notification) {
        if let gameId = notification.object as? Int {
            let gameDetailVC = storyboard?.instantiateViewController(withIdentifier: "GameDetailViewController") as! GameDetailViewController
            gameDetailVC.viewModel = GameDetailViewModel(gameId: gameId)
            gameDetailVC.hidesBottomBarWhenPushed = true
            if let navigationController = self.navigationController {
                navigationController.pushViewController(gameDetailVC, animated: true)
            }
        }
    }
    
}
//MARK: - CollectionView Extension
extension GamesViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.isSearchActive() ? viewModel.searchResultCount : viewModel.gamesCount
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.safeAreaLayoutGuide.layoutFrame.width, height: 96)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCollectionViewCell", for: indexPath) as! GameCollectionViewCell
        let isSearching = viewModel.isSearchActive()
        if let game = viewModel.gameForItem(at: indexPath, isSearching: isSearching) {
            cell.configure(with: game)
        } else {
            print("Hata")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let game = viewModel.gameForItem(at: indexPath,isSearching: !(searchBar.searchTextField.text?.isEmpty ?? true)) else { return }
        let gameDetailVC = storyboard?.instantiateViewController(withIdentifier: "GameDetailViewController") as! GameDetailViewController
        gameDetailVC.viewModel = GameDetailViewModel(gameId: game.id)
        gameDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(gameDetailVC, animated: true)
    }
    
}
//MARK: - PageViewController Extension
extension GamesViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = topRatedGameVCs.firstIndex(of: viewController), vcIndex > 0 else { return nil }
        return topRatedGameVCs[vcIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = topRatedGameVCs.firstIndex(of: viewController), vcIndex < topRatedGameVCs.count - 1 else { return nil }
        return topRatedGameVCs[vcIndex + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            let currentPageIndex = topRatedGameVCs.firstIndex(of: pageViewController.viewControllers!.first!)!
            pageControl.currentPage = currentPageIndex
        }
    }
}
//MARK: - Searchbar Extension
extension GamesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchQuery = searchText
        if viewModel.isSearchActive() {
            containerView.isHidden = true
            pageControl.isHidden = true
            viewModel.searchGames(query: searchText)
        } else {
            containerView.isHidden = false
            pageControl.isHidden = false
            noResultsLabel.isHidden = true
            viewModel.searchResults = []
            viewModel.fetchGames()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = ""
        containerView.isHidden = false
        noResultsLabel.isHidden = true
        viewModel.searchResults = []
        viewModel.fetchGames()
        gamesDidUpdate()
    }

}
//MARK: - GamesViewModelDelegate Extension
extension GamesViewController: GamesViewModelDelegate {
    func gamesDidUpdate() {
        DispatchQueue.main.async { [weak self] in
            self?.gamesCollectionView.reloadData()
            self?.hideActivityIndicator()
        }
        
    }
    
    func topRatedGamesDidUpdate() {
        DispatchQueue.main.async { [weak self] in
            self?.setupTopRatedGameVCs()
            self?.hideActivityIndicator()
        }
    }
    
    func searchResultsDidUpdate() {
        gamesDidUpdate()
        if viewModel.searchResults.isEmpty == true {
            noResultsLabel.isHidden = false
            noResultsLabel.text = "Sorry, the game you were looking for was not found!"
        } else {
            noResultsLabel.isHidden = true
        }
    }
}
