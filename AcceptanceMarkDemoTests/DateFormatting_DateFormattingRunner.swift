/*
 Copyright (c) 2016 Andrea Bizzotto bizz84@gmail.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

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
