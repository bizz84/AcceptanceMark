/*
 Copyright (c) 2016 Andrea Bizzotto bizz84@gmail.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


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
    case (let .contentInvalidSeparator(leftLine, leftSeparator), let .contentInvalidSeparator(rightLine, rightSeparator)): return leftLine == rightLine && leftSeparator == rightSeparator
    default: return false
    }
}

