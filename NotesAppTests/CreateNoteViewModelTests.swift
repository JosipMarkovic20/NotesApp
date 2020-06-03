//
//  CreatNoteViewModelTests.swift
//  NotesAppTests
//
//  Created by Josip Marković on 31/05/2020.
//  Copyright © 2020 Josip Marković. All rights reserved.
//
@testable import NotesApp
import XCTest
import RxTest
import RxSwift

class CreateNoteViewModelTests: XCTestCase {
    
    var viewModel: CreateNoteViewModel!
    var testScheduler: TestScheduler!
    let disposeBag = DisposeBag()
    var errorObserver: TestableObserver<Bool>!
    var mockCreateNoteDelegate: MockCreateNoteDelegate!
    var mockUserDefaults: MockUserDefaults!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        testScheduler = TestScheduler(initialClock: 0)
        mockUserDefaults = MockUserDefaults(notes: nil)
        mockCreateNoteDelegate = MockCreateNoteDelegate()
        initializeViewModel()
        errorObserver = testScheduler.createObserver(Bool.self)
        viewModel.output.errorPublisher.subscribe(errorObserver).disposed(by: disposeBag)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        testScheduler = nil
        viewModel = nil
        errorObserver = nil
        mockCreateNoteDelegate = nil
        mockUserDefaults = nil
        super.tearDown()
    }

    func testEmptyDataInitialization(){
        initializeTests()
        XCTAssertFalse(viewModel.output.screenData.isEmpty)
        XCTAssertTrue(viewModel.output.screenData[0] == .titleField(text: ""))
        XCTAssertTrue(viewModel.output.screenData[1] == .contentField(text: ""))
        XCTAssertTrue(viewModel.output.screenData[2] == .saveButton)
    }
    
    func testFilledDataInitialization(){
        viewModel.dependencies.note = Note(title: "Note", date: "30.05.2020.", content: "Content")
        initializeTests()
        XCTAssertFalse(viewModel.output.screenData.isEmpty)
        XCTAssertTrue(viewModel.output.screenData[0] == .titleField(text: "Note"))
        XCTAssertTrue(viewModel.output.screenData[1] == .contentField(text: "Content"))
        XCTAssertTrue(viewModel.output.screenData[2] == .saveButton)
    }
    
    func testTitleInput(){
        initializeTests()
        let oldTitle = viewModel.output.screenData[0]
        viewModel.input.userInteractionSubject.onNext(.titleInput(text: "Note"))
        let newTitle = viewModel.output.screenData[0]
        XCTAssertTrue(oldTitle != newTitle)
    }
    
    func testContentInput(){
        initializeTests()
        let oldContent = viewModel.output.screenData[1]
        viewModel.input.userInteractionSubject.onNext(.contentInput(text: "Content"))
        let newContent = viewModel.output.screenData[1]
        XCTAssertTrue(oldContent != newContent)
    }
    
    func testFailedValidationOnSave(){
        initializeTests()
        viewModel.input.userInteractionSubject.onNext(.saveButtonClicked)
        XCTAssertTrue(errorObserver.events[0].value.element ?? false)
    }
    
    func testSuccesfullSaveValidation(){
        initializeTests()
        viewModel.input.userInteractionSubject.onNext(.titleInput(text: "Note"))
        viewModel.input.userInteractionSubject.onNext(.contentInput(text: "Content"))
        viewModel.input.userInteractionSubject.onNext(.saveButtonClicked)
        XCTAssertTrue(mockCreateNoteDelegate.functionCalled)
    }

    func initializeTests(){
        testScheduler.start()
        viewModel.input.loadDataSubject.onNext(())
    }
    
    func initializeViewModel(){
        viewModel = CreateNoteViewModel(dependencies: CreateNoteViewModel.Dependencies(userDefaultsManager: UserDefaultsManager(userDefaults: mockUserDefaults), subscribeScheduler: testScheduler, note: nil))
        let input = CreateNoteViewModel.Input(loadDataSubject: ReplaySubject.create(bufferSize: 1),
                                             userInteractionSubject: PublishSubject())
        let output = viewModel.transform(input: input)
        output.disposables.forEach { (disposable) in
            disposable.disposed(by: disposeBag)
        }
        viewModel.createNoteDelegate = mockCreateNoteDelegate
    }

}
