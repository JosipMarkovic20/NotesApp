//
//  Note.swift
//  NotesApp
//
//  Created by Josip Marković on 30/05/2020.
//  Copyright © 2020 Josip Marković. All rights reserved.
//

import Foundation

struct Note: Codable, Equatable{
    let title: String
    let date: String
    let content: String
}
