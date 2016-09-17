//
//  DateFormatter.swift
//  AcceptanceMark
//
//  Created by Andrea Bizzotto on 17/09/2016.
//  Copyright © 2016 musevisions. All rights reserved.
//

import Foundation

public extension DateFormatter {

    convenience init(localeIdentifier: String, style: DateFormatter.Style) {
        self.init()
        self.locale = Locale(identifier: localeIdentifier)
        self.dateStyle = style
        self.timeStyle = style
    }

    func string(from components: DateComponents) -> String? {
        
        guard let date = Calendar.current.date(from: components) else {
            return nil
        }
        
        return string(from: date)
    }
}
