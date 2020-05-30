//
//  MockUserDefaults.swift
//  NotesAppTests
//
//  Created by Josip Marković on 30/05/2020.
//  Copyright © 2020 Josip Marković. All rights reserved.
//

@testable import NotesApp
import Foundation

class MockUserDefaults: UserDefaults{
    
    var notes: [Note]?
    
    override func set(_ value: Any?, forKey defaultName: String) {
        if defaultName == UserDefaultsKeys.notes{
            guard let data = value as? Data else { return }
            let note = UserDefaultsManager(userDefaults: self).decodeNotes(from: data)
            notes = note
        }
    }
    
    override func data(forKey defaultName: String) -> Data? {
        if defaultName == UserDefaultsKeys.notes{
            guard let safeNotes = notes else { return nil}
            return UserDefaultsManager(userDefaults: self).encodeNotes(from: safeNotes)
        }
        return nil
    }
}
