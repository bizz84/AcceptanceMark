//
//  MarkdownTableParser.swift
//  AcceptanceMark
//
//  Created by Andrea Bizzotto on 12/08/2016.
//  Copyright © 2016 musevisions. All rights reserved.
//

import Cocoa

enum MarkdownTableParserState {
    case outside
    case header(inputVars: [TestSpec.Variable], outputVars: [TestSpec.Variable])
    case separator
    case content(data: TestSpec.TestData)
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
            
        case .header(_, _):
            state = .separator
            // TODO: Separator validation (all dashes)
            
        case .separator: fallthrough
        case .content:
            state = parseContent(line: line)
            if case .content(let testData) = state {
                testsData.append(testData)
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
        
        let (inputs, outputs) = getInputsOutputs(line: line)
        
        let inputVars = parseTableHeaders(strings: inputs)
        let outputVars = parseTableHeaders(strings: outputs)
        if inputVars.count == inputs.count && outputVars.count == outputs.count {
            return .header(inputVars: inputVars, outputVars: outputVars)
        }
        return .error(message: "error parsing line \(line). Input vars: \(inputVars), output vars: \(outputVars)")
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
    
    
    func parseTableHeaders(strings: [String]) -> [TestSpec.Variable] {
        var variables: [TestSpec.Variable] = []
        
        for string in strings {
            let components = string.components(separatedBy: ":")
            if components.count == 1 {
                variables.append(TestSpec.Variable(name: components.first!, type: .string))
            }
            else if components.count == 2 {
                if let type = TestSpec.VariableType(type: components.last!) {
                    variables.append(TestSpec.Variable(name: components.first!, type: type))
                }
            }
        }
        return variables
    }
    
    func parseContent(line: String) -> MarkdownTableParserState {

        let values = components(for: line)
        if values.count - 1 != inputVars.count + outputVars.count {
            return .error(message: "Invalid number of components in table row. Should be \(inputVars.count + outputVars.count + 1), found: \(values.count)")
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
