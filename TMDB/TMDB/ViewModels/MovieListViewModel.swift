//
//  MovieListViewModel.swift
//  TMDB
//
//  Created by Nishant Patel on 7/25/23.
//

import UIKit

class MovieListViewModel {
    typealias Dependencies = MoviesProviderService

    private let moviesProvider: MoviesProvider
    private var page = 1
    private var totalPages = Int.max
    
    var coordinator: MovieListCoordinator?
    var movies: [Movie] = []
    var keyword = ""
    var shouldUpdate: Bool {
        page <= totalPages
    }
    
    init(with dependencies: Dependencies) {
        self.moviesProvider = dependencies.moviesProviderService
    }
    
    func viewDidLoad() {
        // no-op
    }
    
    func viewDidDisappear() {
        // no-op
    }
    
    func fetchMovies() async {
        await fetchMoviesWith(keyword)
    }
    
    func fetchMoviesWith(_ keyword: String) async {
        do {
            if keyword != self.keyword {
                let movies = try await moviesProvider.getMoviesFor(keyword, and: page, using: .shared)
                self.movies.removeAll()
                self.movies += movies.0
                self.keyword = keyword
                totalPages = movies.1
                page = 1
            } else {
                page += 1
                let movies = try await moviesProvider.getMoviesFor(keyword, and: page, using: .shared)
                self.movies += movies.0
                totalPages = movies.1
            }
        } catch {
            print(error)
        }
    }
    
    func fetchPosterImageFor(_ movie: Movie) async -> UIImage? {
        guard let posterEndpoint = movie.posterPath else {
            return UIImage(named: DeveloperStrings.placeholderImage.rawValue)!
        }
        
        var image: UIImage?
        do {
            image = try await moviesProvider.getPosterImageUsing(posterEndpoint, with: .shared)
        } catch let error {
            print(error)
        }
        
        return image
    }
    
    // MARK: Routing
    
    func handleMovieTappedFor(_ movie: Movie) {
        coordinator?.handleMovieTappedFor(movie)
    }
}
