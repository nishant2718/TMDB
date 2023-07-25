//
//  MovieListCoordinator.swift
//  TMDB
//
//  Created by Nishant Patel on 7/25/23.
//

import UIKit

class MovieListCoordinator: Coordinator {
    
    // MARK: - Properties
    
    var parentCoordinator: Coordinator?
    private(set) var childCoordinators: [Coordinator] = []
    let container = TMDBDependencyContainer()
    
    private let window: UIWindow
    let navigationController = UINavigationController()
    
    var rootViewController: UINavigationController {
        return navigationController
    }
    
    init(with window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let movieListViewModel = MovieListViewModel(with: container)
        movieListViewModel.coordinator = self
        
        let movieListViewController = MovieListViewController()
        movieListViewController.viewModel = movieListViewModel
        
        window.rootViewController = navigationController
        navigationController.setViewControllers([movieListViewController], animated: true)
        window.makeKeyAndVisible()
    }
    
    func childDidComplete(_ childCoordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { coordinator -> Bool in
            return childCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
    
    // MARK: - Routing
    // incoming
}
