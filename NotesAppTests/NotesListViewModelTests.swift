//
//  NotesListTests.swift
//  NotesAppTests
//
//  Created by Josip Marković on 30/05/2020.
//  Copyright © 2020 Josip Marković. All rights reserved.
//

@testable import NotesApp
import XCTest
import RxTest
import RxSwift

class NotesListViewModelTests: XCTestCase {
    
    var viewModel: NotesListViewModel!
    var mockUserDefaults: MockUserDefaults!
    var testScheduler: TestScheduler!
    var mockNotesListDelegate: MockNotesListDelegate!
    let disposeBag = DisposeBag()
    let notes = [Note(title: "Note 0", date: "29.05.2020.", content: ""),
                 Note(title: "Note 1", date: "29.05.2020.", content: ""),
                 Note(title: "Note 2", date: "29.05.2020.", content: "")]

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockUserDefaults = MockUserDefaults(notes: nil)
        testScheduler = TestScheduler(initialClock: 0)
        mockNotesListDelegate = MockNotesListDelegate()
        initializeViewModel()
        super.setUp()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        mockUserDefaults = nil
        testScheduler = nil
        viewModel = nil
        super.tearDown()
    }

    func testDataInitializationWithFilledUserDefaults(){
        testScheduler.start()
        mockUserDefaults = MockUserDefaults(notes: notes)
        // We change userDefaultsManager to one with with some data inside
        viewModel.dependencies.userDefaultsManager = UserDefaultsManager(userDefaults: mockUserDefaults)
        viewModel.input.loadDataSubject.onNext(())
        XCTAssertFalse(viewModel.output.screenData.isEmpty)
        XCTAssertEqual(viewModel.output.screenData.count, 3)
        XCTAssertTrue(viewModel.output.screenData[0] == NotesListViewModel.ItemType.note(note: Note(title: "Note 0", date: "29.05.2020.", content: "")))
    }
    
    func testDataInitializationWithEmptyUserDefaults(){
        initializeTests()
        XCTAssertFalse(viewModel.output.screenData.isEmpty)
        XCTAssertTrue(viewModel.output.screenData[0] == NotesListViewModel.ItemType.empty)
    }
    
    func testAddingNewNote(){
        initializeTests()
        let oldDataCount = viewModel.output.screenData.count
        viewModel.input.userInteractionSubject.onNext(.addNote(note: Note(title: "New Note", date: "29.05.2020.", content: "")))
        viewModel.input.userInteractionSubject.onNext(.addNote(note: Note(title: "New Note 2", date: "29.05.2020.", content: "")))
        let newDataCount = viewModel.output.screenData.count
        XCTAssertGreaterThan(newDataCount, oldDataCount)
    }
    
    func testDeletingNote(){
        initializeTests()
        let oldDataCount = viewModel.output.screenData.count
        viewModel.input.userInteractionSubject.onNext(.addNote(note: Note(title: "New Note", date: "29.05.2020.", content: "")))
        viewModel.input.userInteractionSubject.onNext(.deleteNote(index: 0))
        let newDataCount = viewModel.output.screenData.count
        XCTAssertGreaterThan(oldDataCount, newDataCount)
    }
    
    func testOpenningNote(){
        initializeTests()
        viewModel.input.userInteractionSubject.onNext(.addNote(note: Note(title: "New Note", date: "29.05.2020.", content: "")))
        viewModel.input.userInteractionSubject.onNext(.openDetails(index: 0))
        XCTAssertTrue(mockNotesListDelegate.openNoteCalled)
    }
        
    func initializeTests(){
        testScheduler.start()
        viewModel.input.loadDataSubject.onNext(())
    }
    
    func initializeViewModel(){
        viewModel = NotesListViewModel(dependencies: NotesListViewModel.Dependencies(userDefaultsManager: UserDefaultsManager(userDefaults: mockUserDefaults),
                                                                                     subscribeScheduler: testScheduler))
        let input = NotesListViewModel.Input(loadDataSubject: ReplaySubject.create(bufferSize: 1),
                                             userInteractionSubject: PublishSubject())
        let output = viewModel.transform(input: input)
        output.disposables.forEach { (disposable) in
            disposable.disposed(by: disposeBag)
        }
        viewModel.notesListDelegate = mockNotesListDelegate
    }
}
