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

struct MarkdownParseResult {
    let testSpecs: [TestSpec]
}

enum MarkdownLineType {
    case heading
    case table
    case other
    
    init(line: String) {
        if let first = line.characters.first {
            if first == "#" {
                self = .heading
            }
            else if first == "|" {
                self = .table
            }
            else {
                self = .other
            }
        }
        else {
            self = .other
        }
    }
}

class MarkdownDocumentParser: NSObject {

    class func parse(fileContents: String, inputFilePath: String) -> MarkdownParseResult {
        
        let lines = fileContents.lines.map {
            return ($0 as NSString).trimmingCharacters(in: CharacterSet.whitespaces)
        }.filter {
            return MarkdownLineType(line: $0) != .other
        }
        
        let testSpecs = parse(lines: lines, inputFilePath: inputFilePath)
        
        return MarkdownParseResult(testSpecs: testSpecs)
    }
    
    /*
     * Method to parse markdown lines array into array of TestSpecs. 
     * - Beginning of a TestSpec is marked by a heading line (one or more # characters)
     * - End of a TestSpec is marked by a new heading line, or end of file
     */
    class func parse(lines: [String], inputFilePath: String) -> [TestSpec] {
        
        for line in lines {
            print("\(line)")
        }
        // Split filename
        return [ TestSpec(fileName: inputFilePath, title: "", inputs: [], outputs: [], tests: []) ]
    }
}

// TODO: MarkdownDocumentParserTests
