//
//  Movie.swift
//  TMDB
//
//  Created by Nishant Patel on 7/25/23.
//

import Foundation

struct Movies: Codable, Hashable {
    var results: [Movie]
}

struct Movie: Codable, Hashable {
    // TODO: Remove the ones you don't need
    var adult: Bool
    var backdropPath: String?
    var genreIds: [Int]
    var id: Int
    var originalLanguage: String
    var originalTitle: String
    var overview: String
    var popularity: Double
    var posterPath: String?
    var releaseDate: String
    var title: String
    var video: Bool
    var voteAverage: Double
    var voteCount: Int
}
