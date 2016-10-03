//
//  MarkdownTableParserStateEquatable.swift
//  AcceptanceMark
//
//  Created by Andrea Bizzotto on 03/10/2016.
//  Copyright © 2016 musevisions. All rights reserved.
//


extension MarkdownTableParserState: Equatable {

}

extension TestSpec.Variable: Equatable {
    
}

func == (lhs: TestSpec.Variable, rhs: TestSpec.Variable) -> Bool {
    
    return lhs.name == rhs.name && lhs.type == rhs.type
}

//extension TestSpec.VariableType: Equatable {
//    
//}
//
//func == (lhs: TestSpec.VariableType, rhs: TestSpec.VariableType) -> Bool {
//    
//    switch (lhs, rhs) {
//    case (.bool, .bool): return true
//    case (.int, .int): return true
//    case (.float, .float): return true
//    case (.string, .string): return true
//    default: return false
//    }
//}


extension TestSpec.TestData: Equatable {
    
}

func == (lhs: TestSpec.TestData, rhs: TestSpec.TestData) -> Bool {

    return lhs.inputs == rhs.inputs && lhs.outputs == rhs.outputs
}

func == (lhs: MarkdownTableParserState, rhs: MarkdownTableParserState) -> Bool {
    
    switch (lhs, rhs) {
    case (.outside, .outside): return true
    case (let .header(lhsInputVars, lhsOutputVars), let .header(rhsInputVars, rhsOutputVars)): return lhsInputVars == rhsInputVars && lhsOutputVars == rhsOutputVars
    case (.separator, .separator): return true
    case (let .content(lhsData), let .content(rhsData)): return lhsData == rhsData
    case (let .error(lhsMessage), let .error(rhsMessage)): return lhsMessage == rhsMessage
    default: return false
    }
}

extension MarkdownTableParserError: Equatable {
    
}

func == (lhs: MarkdownTableParserError, rhs: MarkdownTableParserError) -> Bool {
    switch (lhs, rhs) {
    case (let .noInputsNoOutputs(leftLine), let .noInputsNoOutputs(rightLine)): return leftLine == rightLine
    case (let .missingStartPipe(leftLine), let .missingStartPipe(rightLine)): return leftLine == rightLine
    case (let .missingEndPipe(leftLine), let .missingEndPipe(rightLine)): return leftLine == rightLine
    case (let .invalidHeader(leftLine, leftMessage), let .invalidHeader(rightLine, rightMessage)): return leftLine == rightLine && leftMessage == rightMessage
    case (let .contentInvalidComponentCount(leftLine, leftMessage), let .contentInvalidComponentCount(rightLine, rightMessage)): return leftLine == rightLine && leftMessage == rightMessage
    case (let .invalidSeparator(leftLine, leftMessage), let .invalidSeparator(rightLine, rightMessage)): return leftLine == rightLine && leftMessage == rightMessage
    default: return false
    }
}

