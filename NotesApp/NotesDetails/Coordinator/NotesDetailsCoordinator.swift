//
//  NotesDetailsCoordinator.swift
//  NotesApp
//
//  Created by Josip Marković on 28/05/2020.
//  Copyright © 2020 Josip Marković. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class NotesDetailsCoordinator: Coordinator{
    
    var childCoordinators: [Coordinator] = []
    let presenter: UINavigationController
    var viewController: NotesDetailsViewController!
    let note: Note
    
    init(presenter: UINavigationController, note: Note) {
        self.presenter = presenter
        self.note = note
    }
    
    deinit {
        print("deinit \(self)")
    }
    
    func start(){
        let storyboard = UIStoryboard(name: "NotesDetailsViewController", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "NotesDetailsController") as? NotesDetailsViewController
        let viewModel = NotesDetailsViewModel(dependencies: NotesDetailsViewModel.Dependencies(subscribeScheduler: ConcurrentDispatchQueueScheduler(qos: .background),
                                                                                               note: note))
        viewController.viewModel = viewModel
        viewController.detailsDelegate = self
        presenter.pushViewController(viewController, animated: true)
    }
}

extension NotesDetailsCoordinator: ParentCoordinatorDelegate{
    func childHasFinished(coordinator: Coordinator) {
        removeChildCoordinator(coordinator)
    }
}

extension NotesDetailsCoordinator: CoordinatorDelegate{
    func viewControllerHasFinished() {
        childCoordinators.removeAll()
        childHasFinished(coordinator: self)
    }
}

extension NotesDetailsCoordinator: NotesDetailsDelegate{
    func editNote(note: Note) {
        let coordinator = CreateNoteCoordinator(presenter: presenter, note: note)
        addChildCoordinator(coordinator)
        coordinator.viewController.viewModel.createNoteDelegate = self.viewController.viewModel
        coordinator.start()
        coordinator.viewController.coordinatorDelegate = self
    }
}
