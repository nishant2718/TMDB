//
//  MovieDetailViewModel.swift
//  TMDB
//
//  Created by Nishant Patel on 7/26/23.
//

import UIKit

class MovieDetailViewModel {
    typealias Dependencies = MoviesProviderService
    
    var coordinator: MovieDetailCoordinator?
    private let moviesProvider: MoviesProvider
    private let dateFormatter = DateFormatter()
    let movie: Movie
    
    init(with movie: Movie, and dependencies: Dependencies) {
        self.moviesProvider = dependencies.moviesProviderService
        self.movie = movie
    }
    
    func viewDidDisappear() {
        coordinator?.complete()
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
    
    func readableDateFormatFrom(_ date: String) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var dateString = date
        guard let date = dateFormatter.date(from: dateString) else { return date }
        
        dateFormatter.dateStyle = .long
        
        dateString = dateFormatter.string(from: date)
        
        return dateString
    }
}
