//
//  NotesListCoordinator.swift
//  NotesApp
//
//  Created by Josip Marković on 28/05/2020.
//  Copyright © 2020 Josip Marković. All rights reserved.
//

import Foundation
import UIKit

class NotesListCoordinator: Coordinator{
    
    var childCoordinators: [Coordinator] = []
    let presenter: UINavigationController
    let viewController: NotesListViewController
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.viewController = NotesListCoordinator.createNotesListController()
    }
    
    func start(){
        presenter.pushViewController(viewController, animated: true)
    }
    
    static func createNotesListController() -> NotesListViewController{
        let viewModel = NotesListViewModel(dependencies: NotesListViewModel.Dependencies())
        let controller = NotesListViewController(viewModel: viewModel)
        return controller
    }
}

extension NotesListCoordinator: ParentCoordinatorDelegate{
    func childHasFinished(coordinator: Coordinator) {
        removeChildCoordinator(coordinator)
    }
}

extension NotesListCoordinator: CoordinatorDelegate{
    func viewControllerHasFinished() {
        childCoordinators.removeAll()
        childHasFinished(coordinator: self)
    }
}
