/*
 Copyright (c) 2016 Andrea Bizzotto bizz84@gmail.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import Foundation

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
    
    let tableParser: MarkdownTableParser
    
    init(tableParser: MarkdownTableParser = MarkdownTableParser()) {
        self.tableParser = tableParser
    }

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
    private func parse(lines: [String], inputFilePath: String) -> [TestSpec] {
        
        let pathComponents = (inputFilePath as NSString).components(separatedBy: "/")
        let fileName = pathComponents.last ?? ""
        
        var testSpecs: [TestSpec] = []
        
        var testSpec = TestSpec()
        testSpec.fileName = fileName
        
        var testSpecLines: [String] = []
        
        for line in lines {
            switch MarkdownLineType(line: line) {
            case .heading:
                if update(testSpec: &testSpec, with: tableParser, testLines: testSpecLines) {
                    testSpecs.append(testSpec)
                    tableParser.parseTableFinished()
                }
            
                // new test spec
                testSpec.title = parseHeading(line: line)
                testSpecLines = [line]
            case .table:
                let _ = tableParser.parseRow(line: line)
                testSpecLines.append(line)
            case .other:
                break
            }
        }
        if update(testSpec: &testSpec, with: tableParser, testLines: testSpecLines) {
            testSpecs.append(testSpec)
            tableParser.parseTableFinished()
        }
        return testSpecs
    }
    
    private func update(testSpec: inout TestSpec, with tableParser: MarkdownTableParser, testLines: [String]) -> Bool {
        
        if tableParser.hasValidData {
            testSpec.inputVars = tableParser.inputVars
            testSpec.outputVars = tableParser.outputVars
            testSpec.tests = tableParser.testsData
            testSpec.testLines = testLines
            return true
        }
        return false
    }
    
    private func parseHeading(line: String) -> String {
        return line.trimmedNonAlphanumericCharacters()
    }
}
