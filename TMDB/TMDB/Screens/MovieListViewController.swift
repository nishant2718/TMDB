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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
        guard let dataSource, let viewModel else { return }
        
        var snapshot = dataSource.snapshot()
        snapshot.appendSections(Section.allCases)
        dataSource.apply(snapshot)
        
        snapshot.appendItems(viewModel.movies)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func updateSnapshot(with movies: [Movie]) {
        guard let dataSource else { return }

        var snapshot = dataSource.snapshot()
        snapshot.appendItems(movies)
        dataSource.apply(snapshot, animatingDifferences: false, completion: nil)
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
                
                if viewModel.shouldUpdate {
                    await MainActor.run(body: {
                        updateSnapshot(with: viewModel.movies)
                    })
                }
            }
        }
    }
}
