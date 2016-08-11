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
    case success(testSpecs: [TestSpec])
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
        
        let testSpecs = parse(lines: lines, inputFilePath: inputFilePath)
        
        return .success(testSpecs: testSpecs)
    }
    
    /*
     * Method to parse markdown lines array into array of TestSpecs. 
     * - Beginning of a TestSpec is marked by a heading line (one or more # characters)
     * - End of a TestSpec is marked by a new heading line, or end of file
     */
    class func parse(lines: [String], inputFilePath: String) -> [TestSpec] {
        
        // Split filename
        return [ TestSpec(fileName: inputFilePath, title: "", inputs: [], outputs: [], tests: []) ]
    }
}
