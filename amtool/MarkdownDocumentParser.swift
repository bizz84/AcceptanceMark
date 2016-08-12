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
    
    let tableParser = MarkdownTableParser()

    func parse(fileContents: String, inputFilePath: String) -> MarkdownParseResult {
        
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
    func parse(lines: [String], inputFilePath: String) -> [TestSpec] {
        
        let pathComponents = (inputFilePath as NSString).components(separatedBy: "/")
        let fileName = pathComponents.last ?? ""
        
        var testSpecs: [TestSpec] = []
        
        var testSpec = TestSpec()
        testSpec.fileName = fileName
        
        for line in lines {
            switch MarkdownLineType(line: line) {
            case .heading:
                if update(testSpec: &testSpec, with: tableParser) {
                    testSpecs.append(testSpec)
                }
            
                // new test spec
                testSpec = TestSpec()
                testSpec.title = parseHeading(line: line)
            case .table:
                let _ = tableParser.parseTable(line: line)
                //print("\(tableState)")
            case .other:
                break
            }
        }
        if update(testSpec: &testSpec, with: tableParser) {
            testSpecs.append(testSpec)
        }
        return testSpecs
    }
    
    func update(testSpec: inout TestSpec, with tableParser: MarkdownTableParser) -> Bool {
        
        if tableParser.hasValidData {
            testSpec.inputVars = tableParser.inputVars
            testSpec.outputVars = tableParser.outputVars
            testSpec.tests = tableParser.testsData
            return true
        }
        return false
    }
    
    func parseHeading(line: String) -> String {
        // Trim all non alphanumeric characters
        return (line as NSString).trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    }
}

// TODO: MarkdownDocumentParserTests
