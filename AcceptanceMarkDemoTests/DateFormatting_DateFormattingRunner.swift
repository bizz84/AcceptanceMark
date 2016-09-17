//
//  DateFormatting_DateFormattingRunner.swift
//  AcceptanceMark
//
//  Created by Andrea Bizzotto on 17/09/2016.
//  Copyright © 2016 musevisions. All rights reserved.
//

import Foundation

@testable import AcceptanceMarkDemo

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
        
        let dateFormatter = DateFormatter(localeIdentifier: input.language, style: style)
        
        let localized = dateFormatter.string(from: components) ?? ""
        
        return DateFormatting_DateFormattingOutput(localizedDate: localized)
	}
}
