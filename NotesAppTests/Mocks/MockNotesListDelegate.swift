//
//  MockNotesListDelegate.swift
//  NotesAppTests
//
//  Created by Josip Marković on 30/05/2020.
//  Copyright © 2020 Josip Marković. All rights reserved.
//

@testable import NotesApp
import Foundation

class MockNotesListDelegate: NotesListDelegate{

    var openNoteCalled = false
    var openAddNoteCalled = false
    
    func openNote(note: Note) {
        openNoteCalled = true
    }
    
    func openAddNote() {
        openAddNoteCalled = true
    }
}
