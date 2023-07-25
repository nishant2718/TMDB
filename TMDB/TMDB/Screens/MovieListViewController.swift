//
//  MovieListViewController.swift
//  TMDB
//
//  Created by Nishant Patel on 7/25/23.
//

import UIKit

class MovieListViewController: UIViewController {
    var viewModel: MovieListViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemIndigo
        title = "Hello" // TODO: move this to strings file
        
        viewModel?.viewDidLoad()
        // setupLayout()
        // configureDataSource()
        // applyInitialSnapshot()
    }
}
