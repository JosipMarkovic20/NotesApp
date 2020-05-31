//
//  NotesListDelegate.swift
//  NotesApp
//
//  Created by Josip Marković on 30/05/2020.
//  Copyright © 2020 Josip Marković. All rights reserved.
//

import Foundation


protocol NotesListDelegate: class{
    func openNote(note: Note)
    func openAddNote()
}
