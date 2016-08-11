//
//  MarkdownDocumentParser.swift
//  AcceptanceMark
//
//  Created by Andrea Bizzotto on 11/08/2016.
//  Copyright © 2016 musevisions. All rights reserved.
//

extension String {
    var lines:[String] {
        var result:[String] = []
        enumerateLines { (line, stop) in
            result.append(line)
        }
        return result
    }
}

enum MarkdownParseResult {
    case error(message: String)
    case success
}

class MarkdownDocumentParser: NSObject {

    class func parse(inputFilePath: String) -> MarkdownParseResult {
        guard let data = FileManager.default.contents(atPath: inputFilePath) else {
            return .error(message: "Invalid file contents at path: \(inputFilePath)")
        }
        
        guard let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as? String else {
            return .error(message: "Could not decode file contents at path: \(inputFilePath)")
        }
        
        let lines = string.lines.filter { return $0.characters.count > 0 }

        return .error(message: "not implemented")
    }
}
