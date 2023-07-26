//
//  MovieDetailViewModel.swift
//  TMDB
//
//  Created by Nishant Patel on 7/26/23.
//

import Foundation

class MovieDetailViewModel {
    var coordinator: MovieDetailCoordinator?
    let movie: Movie
    
    init(with movie: Movie) {
        self.movie = movie
    }
    
    func viewDidDisappear() {
        coordinator?.complete()
    }
}
