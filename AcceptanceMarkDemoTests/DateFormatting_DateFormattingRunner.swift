//
//  DateFormatting_DateFormattingRunner.swift
//  AcceptanceMark
//
//  Created by Andrea Bizzotto on 17/09/2016.
//  Copyright © 2016 musevisions. All rights reserved.
//

import Foundation

extension DateFormatter.Style {
    
    init(styleString: String) {
        switch styleString {
        case "full": self = .full
        case "long": self = .long
        case "medium": self = .medium
        case "short": self = .short
        case "none": self = .none
        default: self = .medium
        }
    }
}

class DateFormatting_DateFormattingRunner : DateFormatting_DateFormattingRunnable {

	func run(input: DateFormatting_DateFormattingInput) throws -> DateFormatting_DateFormattingOutput {
        
        var components = DateComponents()
        components.year = input.year
        components.month = input.month
        components.day = input.day
        components.hour = input.hour
        components.minute = input.minute
        components.second = input.second
        
        let style = DateFormatter.Style(styleString: input.dateStyle)
        
        let localized = localizedDate(from: components, localeIdentifier: input.language, style: style)
        
        return DateFormatting_DateFormattingOutput(localizedDate: localized)
	}
    
    func localizedDate(from components: DateComponents, localeIdentifier: String, style: DateFormatter.Style) -> String {
        
        if let date = Calendar.current.date(from: components) {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: localeIdentifier)
            dateFormatter.dateStyle = style
            dateFormatter.timeStyle = style
            return dateFormatter.string(from: date)
        }
        
        return ""
    }
}
