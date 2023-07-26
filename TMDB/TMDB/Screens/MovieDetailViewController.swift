//
//  MovieDetailViewController.swift
//  TMDB
//
//  Created by Nishant Patel on 7/26/23.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    var viewModel: MovieDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemIndigo
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel?.viewDidDisappear()
    }
}
