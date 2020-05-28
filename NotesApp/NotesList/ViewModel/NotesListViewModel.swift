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
        
    }
    
    struct Output{
        
    }
    
    struct Dependencies{
        
    }
    
    var input: Input!
    var output: Output!
    let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        self.input = input
        self.output = output
        return output
    }
}
