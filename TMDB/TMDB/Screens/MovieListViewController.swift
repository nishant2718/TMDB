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
    
    private struct UX {
        static let emptyLabelFontSize: CGFloat = 16
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
    
    lazy private var emptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = .MovieList.NoResults
        label.font = UIFont.systemFont(ofSize: UX.emptyLabelFontSize, weight: .regular)
        label.textColor = .label
        label.layer.zPosition = 10
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationItem.hidesSearchBarWhenScrolling = false
        title = .MovieList.Title

        configureSearchBar()
        setupLayout()
        configureDataSource()
        applyInitialSnapshot()
    }
    
    private func createSectionLayout() -> UICollectionViewLayout {
        let listConfig = UICollectionLayoutListConfiguration(appearance: .plain)
        
        return UICollectionViewCompositionalLayout.list(using: listConfig)
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
        let movieCellRegistration = UICollectionView.CellRegistration<MovieListCell, Movie> { (cell, indexPath, movie) in
            cell.movieTitleLabel.text = movie.title
            cell.movieYearLabel.text = String(movie.releaseDate.prefix(4))
            
            Task {
                let image = await self.viewModel?.fetchPosterImageFor(movie)

                await MainActor.run(body: {
                    cell.posterImageView.image = image
                })
            }
        }
        
        // dataSource setup
        dataSource = UICollectionViewDiffableDataSource<Section, Movie> (collectionView: collectionView) { (collectionView, indexPath, movie) -> UICollectionViewCell in
            let cell = collectionView.dequeueConfiguredReusableCell(using: movieCellRegistration,
                                                                    for: indexPath,
                                                                    item: movie)
            return cell
        }
    }
    
    @MainActor
    private func applyInitialSnapshot() {
        guard let dataSource else { return }
        
        var snapshot = dataSource.snapshot()
        snapshot.appendSections(Section.allCases)
        dataSource.apply(snapshot)
        
        configureEmptyStateLabel()
    }
    
    private func updateSnapshot(with movies: [Movie],
                                using newKeyword: Bool = false) {
        guard let dataSource else { return }

        var snapshot = dataSource.snapshot()
        
        if newKeyword {
            snapshot.deleteAllItems()
            
            snapshot.appendSections(Section.allCases)
            dataSource.apply(snapshot)
            
            if movies.isEmpty {
                purgeCollectionView()
            } else {
                snapshot.appendItems(movies)
                dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
                
                emptyLabel.isHidden = true
            }
        } else {
            if snapshot.sectionIdentifiers.count > 0 {
                snapshot.appendItems(movies)
                dataSource.apply(snapshot, animatingDifferences: false, completion: nil)
            } else {
                var snapshot = dataSource.snapshot()
                snapshot.appendSections(Section.allCases)
                dataSource.apply(snapshot)
                
                snapshot.appendItems(movies)
                dataSource.apply(snapshot, animatingDifferences: false, completion: nil)
                
                emptyLabel.isHidden = true
            }
        }
    }
    
    private func purgeCollectionView() {
        guard let dataSource else { return }

        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        dataSource.apply(snapshot)
        
        emptyLabel.isHidden = false
    }
    
    private func configureEmptyStateLabel() {
        view.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.widthAnchor.constraint(equalToConstant: 80),
            emptyLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureSearchBar() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
}

extension MovieListViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let viewModel else { return }

        guard let text = searchController.searchBar.text, !text.isEmpty else {
            emptyLabel.isHidden = false
            purgeCollectionView()
            viewModel.keyword.removeAll()
            return
        }
        
        guard viewModel.keyword != text else { return }
        
        Task {
            await viewModel.fetchMoviesWith(text)
            updateSnapshot(with: viewModel.movies, using: true)
        }
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
        guard let viewModel else { return }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            Task {
                await viewModel.fetchMovies()
                
                if viewModel.shouldUpdate, emptyLabel.isHidden {
                    await MainActor.run(body: {
                        updateSnapshot(with: viewModel.movies)
                    })
                }
            }
        }
    }
}
