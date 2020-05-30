//
//  UserDefaultsManager.swift
//  NotesApp
//
//  Created by Josip Marković on 30/05/2020.
//  Copyright © 2020 Josip Marković. All rights reserved.
//

import Foundation

struct UserDefaultsKeys{
    static let notes = "notes"
}

class UserDefaultsManager{
    
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    let defaults: UserDefaults
    
    init(userDefaults: UserDefaults) {
        defaults = userDefaults
    }
    
    func addNewNote(note: Note) -> String? {
        if let notesData = defaults.data(forKey: UserDefaultsKeys.notes){
            var decodedNotes = decodeNotes(from: notesData)
            decodedNotes.append(note)
            if let encodedNotes = encodeNotes(from: decodedNotes){
                defaults.set(encodedNotes, forKey: UserDefaultsKeys.notes)
                return ""
            }
        }else{
            let notes = [note]
            if let encodedNotes = encodeNotes(from: notes){
                defaults.set(encodedNotes, forKey: UserDefaultsKeys.notes)
                return ""
            }
        }
        return nil
    }
    
    func deleteNote(note: Note) -> String? {
        if let notesData = defaults.data(forKey: UserDefaultsKeys.notes){
            var decodedNotes = decodeNotes(from: notesData)
            decodedNotes.removeAll { (oldNote) -> Bool in
                note == oldNote
            }
            if let encodedNotes = encodeNotes(from: decodedNotes){
                defaults.set(encodedNotes, forKey: UserDefaultsKeys.notes)
                return ""
            }
        }
        return nil
    }
    
    func editNote(oldNote: Note, newNote: Note) -> String? {
        if let notesData = defaults.data(forKey: UserDefaultsKeys.notes){
            var decodedNotes = decodeNotes(from: notesData)
            let oldNoteIndex = decodedNotes.firstIndex { (note) -> Bool in
                note == oldNote
            }
            guard let safeIndex = oldNoteIndex else { return nil}
            decodedNotes[safeIndex] = newNote
            if let encodedNotes = encodeNotes(from: decodedNotes){
                defaults.set(encodedNotes, forKey: UserDefaultsKeys.notes)
                return ""
            }
        }
        return nil
    }
    
    func getNotes() -> [Note]{
        if let notesData = defaults.data(forKey: UserDefaultsKeys.notes){
            return decodeNotes(from: notesData)
        }
        return []
    }
    
    func decodeNotes(from data: Data) -> [Note]{
        do {
            return try decoder.decode([Note].self, from: data)
        } catch {
            print("Error while decoding \(error)")
            return []
        }
    }
    
    func encodeNotes(from notes: [Note]) -> Data?{
        do{
            return try encoder.encode(notes)
        } catch {
            print("Error while encoding \(error)")
            return nil
        }
    }
    
}
