//
//  UserDefaultsManagerTests.swift
//  NotesAppTests
//
//  Created by Josip Marković on 30/05/2020.
//  Copyright © 2020 Josip Marković. All rights reserved.
//

@testable import NotesApp
import XCTest

class UserDefaultsManagerTests: XCTestCase {
    
    var mockUserDefaults: MockUserDefaults!
    var userDefaultsManager: UserDefaultsManager!
    var testNote: Note!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockUserDefaults = MockUserDefaults(notes: nil)
        userDefaultsManager = UserDefaultsManager(userDefaults: mockUserDefaults)
        testNote = Note(title: "Title", date: "29.05.2020.", content: "Content")
        super.setUp()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        mockUserDefaults = nil
        userDefaultsManager = nil
        testNote = nil
        super.tearDown()
    }

    func testGettingNotes(){
        // Expect to get empty array because currently we do not have any notes
        XCTAssertEqual(userDefaultsManager.getNotes().count, 0)
        saveNotes()
        saveNotes()
        // Now we expect to get an array with two items
        XCTAssertEqual(userDefaultsManager.getNotes().count, 2)
    }
    
    func saveNotes(){
        // Set data to defaults
        let addNoteResult = userDefaultsManager.addNewNote(note: testNote)
        // Result should not be nil
        XCTAssertNotNil(addNoteResult)
    }
    
    func testDeletingNotes(){
        // First add note to initally empty user defaults
        saveNotes()
        // Get old number of notes for later comparison
        let oldNumberOfNotes = userDefaultsManager.getNotes().count
        // Delete note from user defaults
        let deleteResult = userDefaultsManager.deleteNote(note: testNote)
        // Result should not be nil
        XCTAssertNotNil(deleteResult)
        // Get the new number of notes
        let newNumberOfNotes = userDefaultsManager.getNotes().count
        // We are expecting different number of notes
        XCTAssertNotEqual(oldNumberOfNotes, newNumberOfNotes)
    }
    
    func testEditingNotes(){
        // First add note to initally empty user defaults
        saveNotes()
        // Get the old note for later comparison
        guard let oldNote = userDefaultsManager.getNotes().first else { return }
        let newNote = Note(title: "New Title", date: "29.05.2020.", content: "New Content")
        let editResult = userDefaultsManager.editNote(oldNote: oldNote, newNote: newNote)
        // Check the result
        XCTAssertNotNil(editResult)
        // Get the new note
        guard let note = userDefaultsManager.getNotes().first else { return }
        XCTAssertNotEqual(oldNote, note)
    }

}
