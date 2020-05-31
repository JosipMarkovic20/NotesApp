//
//  CreateNoteCoordinator.swift
//  NotesApp
//
//  Created by Josip Marković on 28/05/2020.
//  Copyright © 2020 Josip Marković. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class CreateNoteCoordinator: Coordinator{
    
    var childCoordinators: [Coordinator] = []
    let presenter: UINavigationController
    let viewController: CreateNoteViewController
    
    init(presenter: UINavigationController, note: Note?) {
        self.presenter = presenter
        self.viewController = CreateNoteCoordinator.createViewController(note: note)
    }
    
    deinit {
        print("deinit \(self)")
    }
    
    func start(){
        presenter.pushViewController(viewController, animated: true)
    }
    
    static func createViewController(note: Note?) -> CreateNoteViewController{
        let viewModel = CreateNoteViewModel(dependencies: CreateNoteViewModel.Dependencies(subscribeScheduler: ConcurrentDispatchQueueScheduler(qos: .background),
                                                                                           note: note))
        return CreateNoteViewController(viewModel: viewModel)
    }
}


extension CreateNoteCoordinator: ParentCoordinatorDelegate{
    func childHasFinished(coordinator: Coordinator) {
        removeChildCoordinator(coordinator)
    }
}

extension CreateNoteCoordinator: CoordinatorDelegate{
    func viewControllerHasFinished() {
        childCoordinators.removeAll()
        childHasFinished(coordinator: self)
    }
}
