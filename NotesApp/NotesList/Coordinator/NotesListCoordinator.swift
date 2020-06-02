//
//  NotesListCoordinator.swift
//  NotesApp
//
//  Created by Josip Marković on 28/05/2020.
//  Copyright © 2020 Josip Marković. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class NotesListCoordinator: Coordinator{
    
    var childCoordinators: [Coordinator] = []
    let presenter: UINavigationController
    let viewController: NotesListViewController
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.viewController = NotesListCoordinator.createNotesListController()
    }
    
    deinit {
        print("deinit \(self)")
    }
    
    func start(){
        viewController.viewModel.notesListDelegate = self
        presenter.pushViewController(viewController, animated: true)
    }
    
    static func createNotesListController() -> NotesListViewController{
        let viewModel = NotesListViewModel(dependencies: NotesListViewModel.Dependencies(userDefaultsManager: UserDefaultsManager(userDefaults: UserDefaults.standard), subscribeScheduler: ConcurrentDispatchQueueScheduler(qos: .background)))
        let controller = NotesListViewController(viewModel: viewModel)
        return controller
    }
}

extension NotesListCoordinator: NotesListDelegate{
    func openNote(note: Note) {
        let coordinator = NotesDetailsCoordinator(presenter: presenter, note: note)
        addChildCoordinator(coordinator)
        coordinator.start()
        coordinator.viewController.coordinatorDelegate = self
    }
    
    func openAddNote() {
        let coordinator = CreateNoteCoordinator(presenter: presenter, note: nil)
        addChildCoordinator(coordinator)
        coordinator.viewController.viewModel.createNoteDelegate = self.viewController.viewModel
        coordinator.start()
        coordinator.viewController.coordinatorDelegate = self
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
