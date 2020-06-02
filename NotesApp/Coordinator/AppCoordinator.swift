//
//  AppCoordinator.swift
//  NotesApp
//
//  Created by Josip Marković on 28/05/2020.
//  Copyright © 2020 Josip Marković. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator{
    
    var childCoordinators: [Coordinator] = []
    var window: UIWindow
    let presenter: UINavigationController
    
    
    init(window: UIWindow){
        self.window = window
        self.presenter = UINavigationController()
    }
    
    
    func start() {
        #warning("ovdje srediti nav bar stil i ne zaboraviti svuda handlat boje za dark i light mode")
        presenter.navigationBar.backgroundColor = .green
        let notesListCoordinator = NotesListCoordinator(presenter: self.presenter)
        window.rootViewController = presenter
        window.makeKeyAndVisible()
        self.addChildCoordinator(notesListCoordinator)
        notesListCoordinator.start()
    }
}
