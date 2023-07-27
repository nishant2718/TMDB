//
//  MockMoviesProvider.swift
//  TMDBTests
//
//  Created by Nishant Patel on 7/26/23.
//

import UIKit

@testable import TMDB

class MockMoviesProvider: MoviesProvider {
    var count = 0
    func getMoviesFor(_ keyword: String,
                      and page: Int,
                      using urlSession: URLSession) async throws -> ([Movie], Int) {
        count += 1
        let movies = provideMovieFixturesUntil(3)
        return (movies, movies.count)
    }

    func getPosterImageUsing(_ link: String,
                             with urlSession: URLSession) async throws -> UIImage {
        count += 1
        return UIImage()
    }
    
    private func provideMovieFixturesUntil(_ numberOfMovies: Int) -> [Movie] {
        var movies: [Movie] = []
        
        for _ in 0...numberOfMovies {
            let movie = Movie(adult: true,
                              genreIds: [],
                              id: movies.count,
                              originalLanguage: "Gibberish",
                              originalTitle: "Overwatch",
                              overview: "Movie overview",
                              popularity: 9.9,
                              releaseDate: "2029-12-12",
                              title: "The best movie title",
                              video: false,
                              voteAverage: 9.8,
                              voteCount: 9999)
            
            movies.append(movie)
        }
        
        return movies
    }
}
