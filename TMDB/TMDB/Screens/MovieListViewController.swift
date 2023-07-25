//
//  MovieListViewController.swift
//  TMDB
//
//  Created by Nishant Patel on 7/25/23.
//

import UIKit

class MovieListViewController: UIViewController {
    enum Section: Int, CaseIterable {
        case list
    }
    
    // MARK: Properties
    
    var viewModel: MovieListViewModel?
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Movie>?
    lazy private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createSectionLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = .MovieList.Title
        
        viewModel?.viewDidLoad()
        setupLayout()
        configureDataSource()
        applyInitialSnapshot()
    }
    
    private func createSectionLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionClassifier: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionNumber = Section(rawValue: sectionClassifier) else { return nil }
            let section: NSCollectionLayoutSection
            
            switch sectionNumber {
            case .list:
                // TODO: When the cell is available to work with, tweak these numbers and padding
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.4))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
//                group.interItemSpacing = .fixed(UX.interItemSpacing)
                
                section = NSCollectionLayoutSection(group: group)
//                section.interGroupSpacing = UX.interGroupSpacing
//                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: UX.contentInsets, bottom: 0, trailing: UX.contentInsets)
            }
            
            return section
        }
        
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
    
    private func setupLayout() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func configureDataSource() {
        // Movie cell UI
        let movieCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Movie> { (cell, indexPath, movie) in
            // TODO: Wrap poster image fetching in a task
            Task { }
            
            // TODO: Configure the rest of the cell UI items
            // cell.titleLabel.text = movie.originalTitle
            // cell.yearLabel.text = movie.releaseDate
        }
        
        // dataSource setup
        dataSource = UICollectionViewDiffableDataSource<Section, Movie> (collectionView: collectionView) { (collectionView, indexPath, movie) -> UICollectionViewCell in
            let cell = collectionView.dequeueConfiguredReusableCell(using: movieCellRegistration,
                                                                    for: indexPath,
                                                                    item: movie)
            return cell
        }
    }
    
    private func applyInitialSnapshot() {
        guard let dataSource, let viewModel else { return }
        
        var snapshot = dataSource.snapshot()
        snapshot.appendSections(Section.allCases)
        dataSource.apply(snapshot)
        
        // TODO: Fill in the movies for the list
        //  let movies = viewModel.movies
        //  snapshot.appendItems(movies)
        //  dataSource.apply(snapshot)
    }
    
    private func updateSnapshot(with offers: [Movie]) {
        guard let dataSource else { return }

        var snapshot = dataSource.snapshot()
        snapshot.appendItems(offers)
        dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
}

extension MovieListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let movie = dataSource?.itemIdentifier(for: indexPath) else { return }
        
        viewModel?.handleMovieTappedFor(movie)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView,
                                  willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            // TODO: Fill in the update snapshot with newly fetched movies
            // viewModel?.getMovies()
            // updateSnapshot(with: movies)
        }
    }
}
