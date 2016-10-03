//
//  MarkdownTableParserTests.swift
//  AcceptanceMark
//
//  Created by Andrea Bizzotto on 03/10/2016.
//  Copyright © 2016 musevisions. All rights reserved.
//

import XCTest
@testable import amtool

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

    func testLineHeader_AnotherHeader_ErrorState() {
        
        let headerLine = "| name:String   || loaded:Bool  |"
        
        let parser = MarkdownTableParser()
        
        let _ = parser.parseTable(line: headerLine)

        let state = parser.parseTable(line: headerLine)
        
        let expectedState = MarkdownTableParserState.error(error: .invalidSeparator(line: headerLine, message: ""))
        
        XCTAssertEqual(state, expectedState)
    }
    
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
    
}
