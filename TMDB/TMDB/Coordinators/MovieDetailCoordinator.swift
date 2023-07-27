//
//  MovieDetailCoordinator.swift
//  TMDB
//
//  Created by Nishant Patel on 7/26/23.
//

import UIKit

class MovieDetailCoordinator: Coordinator {
    // MARK: Properties
    
    var parentCoordinator: Coordinator?
    private(set) var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    var rootViewController: UINavigationController {
        navigationController
    }
    
    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }
    
    // MARK: Coordinator interface
    
    @discardableResult
    func start(using movie: Movie,
               presentedBy presentationStyle: PresentationStyle,
               with navigationController: UINavigationController,
               and container: TMDBDependencyContainer) -> UIViewController? {
        self.navigationController = navigationController
        
        let movieDetailViewModel = MovieDetailViewModel(with: movie, and: container)
        movieDetailViewModel.coordinator = self
        
        let movieDetailViewController = MovieDetailViewController()
        movieDetailViewController.viewModel = movieDetailViewModel
        
        switch presentationStyle {
        case .push:
            navigationController.pushViewController(movieDetailViewController, animated: true)
        case .present:
            navigationController.present(movieDetailViewController, animated: true)
        case .embed:
            return movieDetailViewController
        }
        
        return nil
    }
    
    func complete() {
        parentCoordinator?.childDidComplete(self)
    }
}
