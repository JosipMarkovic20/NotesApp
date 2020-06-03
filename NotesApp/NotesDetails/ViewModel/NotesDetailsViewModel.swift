//
//  NotesDetailsViewModel.swift
//  NotesApp
//
//  Created by Josip Marković on 28/05/2020.
//  Copyright © 2020 Josip Marković. All rights reserved.
//

import Foundation
import RxSwift

class NotesDetailsViewModel: ViewModelType{
    
    struct Input{
    }
    
    struct Output{
        var disposables: [Disposable]
        let refreshViewSubject: PublishSubject<()>
    }
    
    struct Dependencies{
        let subscribeScheduler: SchedulerType
        var note: Note
    }
    
    var input: Input!
    var output: Output!
    var dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func transform(input: Input) -> Output {
        var disposables = [Disposable]()

        let output = Output(disposables: disposables,
                            refreshViewSubject: PublishSubject())
        self.input = input
        self.output = output
        return output
    }
}

extension NotesDetailsViewModel: CreateNoteDelegate{
    func saveNote(note: Note) {
        dependencies.note = note
        output.refreshViewSubject.onNext(())
    }
}
