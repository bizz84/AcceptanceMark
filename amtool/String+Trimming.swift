//
//  String+Trimming.swift
//  AcceptanceMark
//
//  Created by Andrea Bizzotto on 19/08/2016.
//  Copyright © 2016 musevisions. All rights reserved.
//

import Foundation

extension String {
    func filteredAlphanumericCharacters() -> String {
        
        return String(self.characters.filter { String($0).rangeOfCharacter(from: CharacterSet.alphanumerics) != nil })
    }
    
    func trimmedNonAlphanumericCharacters() -> String {
        return (self as NSString).trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    }
}
