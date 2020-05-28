//
//  CoordinatorDelegate.swift
//  NotesApp
//
//  Created by Josip Marković on 28/05/2020.
//  Copyright © 2020 Josip Marković. All rights reserved.
//

import Foundation
import UIKit


protocol ParentCoordinatorDelegate {
    func childHasFinished(coordinator: Coordinator)
}

protocol CoordinatorDelegate: class {
    func viewControllerHasFinished()
}
