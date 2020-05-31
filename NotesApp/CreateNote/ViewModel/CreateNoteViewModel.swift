//
//  CreateNoteViewModel.swift
//  NotesApp
//
//  Created by Josip Marković on 28/05/2020.
//  Copyright © 2020 Josip Marković. All rights reserved.
//

import Foundation
import RxSwift

class CreateNoteViewModel: ViewModelType{
    
    struct Input{
        let loadDataSubject: ReplaySubject<()>
        let userInteractionSubject: PublishSubject<InteractionType>
    }
    
    struct Output{
        var disposables: [Disposable]
        var screenData: [ItemType]
        let refreshTableView: PublishSubject<TableRefresh>
        let errorPublisher: PublishSubject<Bool>
    }
    
    struct Dependencies{
        let subscribeScheduler: SchedulerType
        var note: Note?
    }
    
    enum InteractionType{
        case titleInput(text: String)
        case contentInput(text: String)
        case saveButtonClicked
    }
    
    enum ItemType: Equatable{
        case titleField(text: String)
        case contentField(text: String)
        case saveButton
    }
    
    var input: Input!
    var output: Output!
    var dependencies: Dependencies
    weak var createNoteDelegate: CreateNoteDelegate?
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func transform(input: Input) -> Output {
        var disposables = [Disposable]()
        disposables.append(initializeScreenData(for: input.loadDataSubject))
        disposables.append(initializeUserInteraction(for: input.userInteractionSubject))
        let output = Output(disposables: disposables,
                            screenData: [],
                            refreshTableView: PublishSubject(),
                            errorPublisher: PublishSubject())
        self.input = input
        self.output = output
        return output
    }
}

extension CreateNoteViewModel{
    
    func initializeScreenData(for subject: ReplaySubject<()>) -> Disposable{
        return subject.map {[unowned self] (_) -> [ItemType] in
            return self.createScreenData(from: self.dependencies.note)
        }
        .subscribeOn(dependencies.subscribeScheduler)
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: {[unowned self] (data) in
            self.output.screenData = data
            self.output.refreshTableView.onNext(.reloadTable)
        })
    }
    
    func createScreenData(from note: Note?) -> [ItemType]{
        var screenData = [ItemType]()
        if let safeNote = note{
            screenData.append(.titleField(text: safeNote.title))
            screenData.append(.contentField(text: safeNote.content))
            screenData.append(.saveButton)
        }else{
            screenData.append(.titleField(text: ""))
            screenData.append(.contentField(text: ""))
            screenData.append(.saveButton)
        }
        return screenData
    }
}

extension CreateNoteViewModel{
    
    func initializeUserInteraction(for subject: PublishSubject<InteractionType>) -> Disposable{
        
        return subject
            .subscribeOn(dependencies.subscribeScheduler)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[unowned self] (type) in
                switch type{
                case .titleInput(let text):
                    self.handleTitleInput(text: text)
                case .contentInput(let text):
                    self.handleContentInput(text: text)
                case .saveButtonClicked:
                    self.handleSaveButtonClick()
                }
        })
    }
    
    func handleTitleInput(text: String){
        let newItem = ItemType.titleField(text: text)
        self.output.screenData[0] = newItem
    }
    
    func handleContentInput(text: String){
        let newItem = ItemType.contentField(text: text)
        self.output.screenData[1] = newItem
    }
    
    func handleSaveButtonClick(){
        if validateField(item: output.screenData[0]) && validateField(item: output.screenData[1]){
            guard let safeNote = createNote(titleItem: output.screenData[0], contentItem: output.screenData[1]) else {
                return 
            }
            createNoteDelegate?.saveNote(note: safeNote)
        }else{
            output.errorPublisher.onNext(true)
        }
    }
    
    func createNote(titleItem: ItemType, contentItem: ItemType) -> Note?{
        switch (titleItem, contentItem){
        case (.titleField(let title), .contentField(let content)):
            return Note(title: title, date: DateUtils.getString(from: Date()), content: content)
        default:
            return nil
        }
    }
    
    func validateField(item: ItemType) -> Bool{
        switch item{
        case .titleField(let text), .contentField(let text):
            return !text.isEmpty
        case .saveButton:
            return false
        }
    }
}
