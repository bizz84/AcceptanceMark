//
//  MarkdownTableParser.swift
//  AcceptanceMark
//
//  Created by Andrea Bizzotto on 12/08/2016.
//  Copyright © 2016 musevisions. All rights reserved.
//

import Foundation

enum MarkdownTableParserError {
    case noInputsNoOutputs(line: String)
    case missingStartPipe(line: String)
    case missingEndPipe(line: String)
    case invalidHeader(line: String, message: String)
    case contentInvalidComponentCount(line: String, message: String)
    case invalidSeparator(line: String, message: String)
    
    var message: String {
        switch self {
        case .noInputsNoOutputs(let line): return errorString(line: line, message: "Table row has no inputs and no outputs")
        case .missingStartPipe(let line): return errorString(line: line, message: "Table row does not start with `|` character")
        case .missingEndPipe(let line): return errorString(line: line, message: "Table row does not end with `|` character")
        case .invalidHeader(let line, let message): return errorString(line: line, message: message)
        case .contentInvalidComponentCount(let line, let message): return errorString(line: line, message: message)
        case .invalidSeparator(let line, let message): return errorString(line: line, message: message)
        }
    }
    
    private func errorString(line: String, message: String) -> String {
        return "\(message):\n\(line)"
    }
}

enum MarkdownTableParserState {
    case outside
    case header(inputVars: [TestSpec.Variable], outputVars: [TestSpec.Variable])
    case separator
    case content(data: TestSpec.TestData)
    case error(error: MarkdownTableParserError)
}

enum VariablesOrError {
    case variables(variables: [TestSpec.Variable])
    case error(message: String)
}

class MarkdownTableParser: NSObject {

    var state: MarkdownTableParserState = .outside
    
    var inputVars: [TestSpec.Variable] = []
    var outputVars: [TestSpec.Variable] = []
    
    var testsData: [TestSpec.TestData] = []
    
    var hasValidData: Bool {
        if case .error(_) = state {
            return false
        }
        return outputVars.count > 0 && testsData.count > 0
    }
    
    func parseTable(line: String) -> MarkdownTableParserState {
        switch state {
        case .outside:
            reset()
            state = parseTableHeader(line: line)
            if case .header(let inputVars, let outputVars) = state {
                self.inputVars = inputVars
                self.outputVars = outputVars
            }
            if case .error(let error) = state {
                print("\(error.message)")
            }
            
        case .header(_, _):
            state = .separator
            // TODO: Separator validation (all dashes)
            
        case .separator: fallthrough
        case .content:
            state = parseContent(line: line)
            if case .content(let testData) = state {
                testsData.append(testData)
            }
            if case .error(let message) = state {
                print("\(message)")
            }

        case .error(_):
            break
        }
        return state
    }
    
    func parseTableFinished() {
        state = .outside
        reset()
    }
    
    private func reset() {
        inputVars = []
        outputVars = []
        testsData = []
    }
    
    private func parseTableHeader(line: String) -> MarkdownTableParserState {
        
        let trimmed = (line as NSString).trimmingCharacters(in: CharacterSet.whitespaces)
        if let error = errorMessageForTable(line: trimmed) {
            return .error(error: error)
        }

        let (inputs, outputs) = getInputsOutputs(line: trimmed)
        if inputs.count == 0 && outputs.count == 0 {
            return .error(error: .noInputsNoOutputs(line: line))
        }
        
        let inputHeaders = parseTableHeaders(strings: inputs)
        let outputHeaders = parseTableHeaders(strings: outputs)
        switch (inputHeaders, outputHeaders) {
        case (.error(let inputMessage), .error(_)): return .error(error: .invalidHeader(line: line, message: inputMessage))
        case (.error(let inputMessage), .variables(_)): return .error(error: .invalidHeader(line: line, message: inputMessage))
        case (.variables(_), .error(let outputMessage)): return .error(error: .invalidHeader(line: line, message: outputMessage))
        case (.variables(let inputVars), .variables(let outputVars)):
        
            if inputVars.count == inputs.count && outputVars.count == outputs.count {
                return .header(inputVars: inputVars, outputVars: outputVars)
            }
            else {
                return .error(error: .invalidHeader(line: line, message: "Invalid input / outputs"))
            }
        }
    }

    private func errorMessageForTable(line: String) -> MarkdownTableParserError? {
        
        guard let first = line.characters.first, first == "|" else {
            return .missingStartPipe(line: line)
        }
        guard let last = line.characters.last, last == "|" else {
            return .missingEndPipe(line: line)
        }
        return nil
    }
    
    private func getInputsOutputs(line: String) -> ([String], [String]) {
                
        let values = components(for: line)
        
        var inputs: [String] = []
        var outputs: [String] = []
        if let ioSeparatorIndex = values.index(of: "") {
            // [ i, |, o ]. separator = 1
            inputs = Array(values.dropLast(values.count - ioSeparatorIndex))
            outputs = Array(values.dropFirst(ioSeparatorIndex + 1))
        }
        else {
            outputs = values
        }
        return ( inputs, outputs )
    }
    
    
    func parseTableHeaders(strings: [String]) -> VariablesOrError {
        var variables: [TestSpec.Variable] = []
        
        for string in strings {
            let components = string.components(separatedBy: ":")
            if components.count == 1 {
                let name = components.first!.filteredAlphanumericCharacters()
                variables.append(TestSpec.Variable(name: name, type: .string))
            }
            else if components.count == 2 {
                let name = components.first!.filteredAlphanumericCharacters()
                let type = components.last!.filteredAlphanumericCharacters()
                if let type = TestSpec.VariableType(type: type) {
                    variables.append(TestSpec.Variable(name: name, type: type))
                }
                else {
                    return .error(message: "\(components.first!): Unrecognized variable type: \"\(components.last!)\".\nOnly Bool, Int, Float, String are supported")
                }
            }
            else {
                return .error(message: "invalid table header format: \"\(strings)\"")
            }
        }
        return .variables(variables: variables)
    }
    
    func parseContent(line: String) -> MarkdownTableParserState {

        let trimmed = (line as NSString).trimmingCharacters(in: CharacterSet.whitespaces)
        if let errorMessage = errorMessageForTable(line: trimmed) {
            return .error(error: errorMessage)
        }

        let values = components(for: trimmed)
        if values.count - 1 != inputVars.count + outputVars.count {
            return .error(error: .contentInvalidComponentCount(line: line, message: "Invalid number of components in table row. Should be \(inputVars.count + outputVars.count + 1), found: \(values.count)"))
        }
        
        let ioSeparatorIndex = inputVars.count
        let inputs = Array(values.dropLast(values.count - ioSeparatorIndex))
        let outputs = Array(values.dropFirst(ioSeparatorIndex + 1))
        return .content(data: TestSpec.TestData(inputs: inputs, outputs: outputs))
    }
    
    func components(for line: String) -> [String] {
        
        var components = (line as NSString).components(separatedBy: "|").map {
            return ($0 as NSString).trimmingCharacters(in: CharacterSet.whitespaces)
        }
        components.removeFirst()
        components.removeLast()
        return components
    }
}
