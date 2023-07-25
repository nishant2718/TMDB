//
//  Coordinator.swift
//  TMDB
//
//  Created by Nishant Patel on 7/25/23.
//

import Foundation

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get }
    var parentCoordinator: Coordinator? { get set }
    
    /// Configure the viewModel, view, and other items needed to show this view.
    func start()
    
    /// Deallocate the coordinator when the view is removed.
    func complete()
    
    /// Deallocate the child coordinator reference.
    func childDidComplete(_ childCoordinator: Coordinator)
}

extension Coordinator {
    func start() { }
    func complete() { }
    func childDidComplete(_ childCoordinator: Coordinator) { }
}
