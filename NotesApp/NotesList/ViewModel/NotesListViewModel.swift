//
//  NotesListViewModel.swift
//  NotesApp
//
//  Created by Josip Marković on 28/05/2020.
//  Copyright © 2020 Josip Marković. All rights reserved.
//

import Foundation
import RxSwift

class NotesListViewModel: ViewModelType{
    
    struct Input{
        let loadDataSubject: ReplaySubject<()>
        let userInteractionSubject: PublishSubject<InteractionType>
    }
    
    struct Output{
        var disposables: [Disposable]
        var screenData: [ItemType]
        let refreshTableView: PublishSubject<TableRefresh>
        let errorPublisher: PublishSubject<()>
    }
    
    struct Dependencies{
        var userDefaultsManager: UserDefaultsManager
        let subscribeScheduler: SchedulerType
    }
    
    enum ItemType: Equatable{
        case note(note: Note)
        case empty
    }
    
    enum InteractionType{
        case addNote(note: Note)
        case deleteNote(index: Int)
        case openDetails(index: Int)
    }
    
    var input: Input!
    var output: Output!
    var dependencies: Dependencies
    weak var notesListDelegate: NotesListDelegate?
    
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

extension NotesListViewModel{
    
    func initializeScreenData(for subject: ReplaySubject<()>) -> Disposable{
        return subject
            .map({ (notes) -> [ItemType] in
                let notes = self.dependencies.userDefaultsManager.getNotes()
                return self.createScreenData(from: notes)
            })
            .subscribeOn(dependencies.subscribeScheduler)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[unowned self] (data) in
                self.output.screenData = data
                self.output.refreshTableView.onNext(.reloadTable)
            })
    }
    
    func createScreenData(from notes: [Note]) -> [ItemType]{
        var screenData = [ItemType]()
        notes.forEach { (note) in
            screenData.append(.note(note: note))
        }
        if notes.isEmpty{
            screenData.append(.empty)
        }
        return screenData
    }
}

extension NotesListViewModel{
    
    func initializeUserInteraction(for subject: PublishSubject<InteractionType>) -> Disposable{
        return subject
            .subscribeOn(dependencies.subscribeScheduler)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[unowned self] (type) in
                switch type{
                case .addNote(let note):
                    self.handleAddingNewNote(newNote: note)
                case .deleteNote(let index):
                    self.handleRemovingNote(at: index)
                case .openDetails(let index):
                    self.handleOpenningNote(at: index)
                }
            })
    }
    
    func handleAddingNewNote(newNote: Note){
        let newItem = ItemType.note(note: newNote)
        let indexPath = IndexPath(row: output.screenData.count, section: 0)
        output.screenData.removeAll { (item) -> Bool in
            item == ItemType.empty
        }
        output.screenData.append(newItem)
        output.refreshTableView.onNext(.insertRows(indexPaths: [indexPath]))
    }
    
    func handleRemovingNote(at index: Int){
        output.screenData.remove(at: index)
        let indexPath = IndexPath(row: index, section: 0)
        output.refreshTableView.onNext(.deleteRows(indexPaths: [indexPath]))
    }
    
    func handleOpenningNote(at index: Int){
        let note = output.screenData[index]
        switch note{
        case .note(let note):
            notesListDelegate?.openNote(note: note)
        case .empty:
            break
        }
    }
}
