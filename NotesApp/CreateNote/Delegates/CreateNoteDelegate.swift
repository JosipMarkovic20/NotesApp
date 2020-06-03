//
//  CreateNoteDelegate.swift
//  NotesApp
//
//  Created by Josip Marković on 31/05/2020.
//  Copyright © 2020 Josip Marković. All rights reserved.
//

import Foundation

protocol CreateNoteDelegate: class{
    func saveNote(note: Note)
}
