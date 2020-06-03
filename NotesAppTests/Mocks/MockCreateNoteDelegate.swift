//
//  MockCreateNoteDelegate.swift
//  NotesAppTests
//
//  Created by Josip Marković on 31/05/2020.
//  Copyright © 2020 Josip Marković. All rights reserved.
//

@testable import NotesApp
import Foundation

class MockCreateNoteDelegate: CreateNoteDelegate{
    var functionCalled = false
    
    func saveNote(note: Note) {
        functionCalled = true
    }
}
