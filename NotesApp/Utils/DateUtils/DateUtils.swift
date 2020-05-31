//
//  DateUtils.swift
//  NotesApp
//
//  Created by Josip Marković on 31/05/2020.
//  Copyright © 2020 Josip Marković. All rights reserved.
//

import Foundation

public class DateUtils {
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy."
        return dateFormatter
    }()
    
    static func getString(from date: Date) -> String{
        return dateFormatter.string(from: date)
    }
}
