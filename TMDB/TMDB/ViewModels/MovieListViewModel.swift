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
    
    var coordinator: MovieListCoordinator?
    var movies: [Movie] = []
    var page: Int = 1
    
    init(with dependencies: Dependencies) {
        self.moviesProvider = dependencies.moviesProviderService
    }
    
    func viewDidLoad() {
        Task {
            await fetchMovies()
        }
    }
    
    func viewDidDisappear() {
        // no-op
    }
    
    func fetchMovies() async {
        do {
            let movies = try await moviesProvider.getMoviesFor("hitman",
                                                               and: page,
                                                               using: .shared)
            self.movies += movies
            page += 1
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
        // TODO: Navigate to the details page
        // no-op
    }
}
