//
//  TableRefresh.swift
//  NotesApp
//
//  Created by Josip Marković on 30/05/2020.
//  Copyright © 2020 Josip Marković. All rights reserved.
//

import Foundation

enum TableRefresh{
    case reloadTable
    case deleteRows(indexPaths: [IndexPath])
    case insertRows(indexPaths: [IndexPath])
    case reloadRows(indexPaths: [IndexPath])
}
