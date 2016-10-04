//
//  MarkdownTableParserTests.swift
//  AcceptanceMark
//
//  Created by Andrea Bizzotto on 03/10/2016.
//  Copyright © 2016 musevisions. All rights reserved.
//

import XCTest

class MarkdownTableParserTests: XCTestCase {
        
    // Initialisation Tests
    func testParser_InitialState_OutsideTable() {
        
        let parser = MarkdownTableParser()
        
        XCTAssertEqual(parser.state, .outside)
    }

    // MARK: Header tests
    func testLineHeader_OneInputOneOutput_ParseCorrectly() {
     
        let headerLine = "| name:String   || loaded:Bool  |"
     
        let parser = MarkdownTableParser()

        let state = parser.parseTable(line: headerLine)
        
        let expectedState = MarkdownTableParserState.header(inputVars: [ TestSpec.Variable(name: "name", type: .string) ], outputVars: [ TestSpec.Variable(name: "loaded", type: .bool) ])
        
        XCTAssertEqual(state, expectedState)
    }

    // TODO: Enable this when separator parsing logic is included
//    func testLineHeader_AnotherHeader_ErrorState() {
//        
//        let headerLine = "| name:String   || loaded:Bool  |"
//        
//        let parser = MarkdownTableParser()
//        
//        let _ = parser.parseTable(line: headerLine)
//
//        let state = parser.parseTable(line: headerLine)
//        
//        let expectedState = MarkdownTableParserState.error(error: .invalidSeparator(line: headerLine, message: ""))
//        
//        XCTAssertEqual(state, expectedState)
//    }
    
    func testLineHeader_NoInputsNoOutputs_ErrorState() {
        
        let headerLine = "||"
        
        let parser = MarkdownTableParser()
        
        let state = parser.parseTable(line: headerLine)

        let expectedState = MarkdownTableParserState.error(error: .noInputsNoOutputs(line: headerLine))
        
        XCTAssertEqual(state, expectedState)
    }

    func testLineHeader_NoInputsOneOutput_ParseAsOutput() {
        
        let headerLine = "|valid:Bool|"
        
        let parser = MarkdownTableParser()
        
        let state = parser.parseTable(line: headerLine)
        
        let expectedState = MarkdownTableParserState.header(inputVars: [ ], outputVars: [ TestSpec.Variable(name: "valid", type: .bool) ])
        
        XCTAssertEqual(state, expectedState)
    }
    
    func testLineHeader_MissingStartPipe_Error() {
        
        let headerLine = "name:String   || loaded:Bool |"
        
        let parser = MarkdownTableParser()
        
        let state = parser.parseTable(line: headerLine)
        
        let expectedState = MarkdownTableParserState.error(error: .missingStartPipe(line: headerLine))
        
        XCTAssertEqual(state, expectedState)
    }
    func testLineHeader_MissingEndPipe_Error() {
        
        let headerLine = "| name:String   || loaded:Bool"
        
        let parser = MarkdownTableParser()
        
        let state = parser.parseTable(line: headerLine)
        
        let expectedState = MarkdownTableParserState.error(error: .missingEndPipe(line: headerLine))
        
        XCTAssertEqual(state, expectedState)
    }
    
    // MARK: Separator tests
    
    
    // MARK: Content tests
    func testLineContent_MissingStartPipe_Error() {

        let parser = makeParser(headerLine:    "| name:String   || loaded:Bool  |",
                                separatorLine: "|---------------||--------------|")

        let contentLine = "available.png   || true |"

        let state = parser.parseTable(line: contentLine)

        let expectedState = MarkdownTableParserState.error(error: .missingStartPipe(line: contentLine))

        XCTAssertEqual(state, expectedState)
    }
    
    func testLineContent_MissingEndPipe_Error() {
        
        let parser = makeParser(headerLine:    "| name:String   || loaded:Bool  |",
                                separatorLine: "|---------------||--------------|")
        
        let contentLine = "| available.png   || true"
        
        let state = parser.parseTable(line: contentLine)
        
        let expectedState = MarkdownTableParserState.error(error: .missingEndPipe(line: contentLine))
        
        XCTAssertEqual(state, expectedState)
    }

    func testLineContent_ColumnCountLessThanVariablesCount_Error() {
        
        let parser = makeParser(headerLine:    "| name:String   || loaded:Bool  |",
                                separatorLine: "|---------------||--------------|")
        
        let contentLine = "| available.png   ||"
        
        let state = parser.parseTable(line: contentLine)
        
        let expectedState = MarkdownTableParserState.error(error: .contentInvalidComponentCount(line: contentLine, message: "Invalid number of components in table row. Should be 3, found: 2"))
        
        XCTAssertEqual(state, expectedState)
    }
    func testLineContent_ColumnCountGreaterThanVariablesCount_Error() {
        
        let parser = makeParser(headerLine:    "| name:String   || loaded:Bool  |",
                                separatorLine: "|---------------||--------------|")
        
        let contentLine = "| available.png   || true | false |"
        
        let state = parser.parseTable(line: contentLine)
        
        let expectedState = MarkdownTableParserState.error(error: .contentInvalidComponentCount(line: contentLine, message: "Invalid number of components in table row. Should be 3, found: 4"))
        
        XCTAssertEqual(state, expectedState)
    }
    
    func testLineContent_CorrectColumnCount_CreatesInputsOutputs() {
        
        let parser = makeParser(headerLine:    "| name:String   || loaded:Bool  |",
                                separatorLine: "|---------------||--------------|")
        
        let contentLine = "| available.png   || true |"
            
        let state = parser.parseTable(line: contentLine)
        
        let expectedState = MarkdownTableParserState.content(data: TestSpec.TestData(inputs: [ "available.png" ], outputs: [ "true" ]))

        XCTAssertEqual(state, expectedState)
    }
    
    func testLineContent_InvalidSeparatorColumn_Error() {

        let parser = makeParser(headerLine:    "| name:String   || loaded:Bool  |",
                                separatorLine: "|---------------||--------------|")
        
        let contentLine = "| available.png   |invalid| true |"
        
        let state = parser.parseTable(line: contentLine)
        
        let expectedState = MarkdownTableParserState.error(error: .contentInvalidSeparator(line: contentLine, separator: "invalid"))
        
        XCTAssertEqual(state, expectedState)
    }
    
    // MARK: Helpers
    func makeParser(headerLine: String, separatorLine: String) -> MarkdownTableParser {
        
        let parser = MarkdownTableParser()
        
        let _ = parser.parseTable(line: headerLine)
        let _ = parser.parseTable(line: separatorLine)
        
        return parser
    }
    
}
