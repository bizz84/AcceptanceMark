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
    case content
    case error(message: String)
}

class MarkdownTableParser: NSObject {

    var state: MarkdownTableParserState = .outside
    var testSpec = TestSpec()
    
    func parseTable(line: String) -> MarkdownTableParserState {
        let (inputs, outputs) = getInputsOutputs(line: line)
        
        switch state {
        case .outside:
            let inputVars = parseTableHeaders(strings: inputs)
            let outputVars = parseTableHeaders(strings: outputs)
            if inputVars.count == inputs.count && outputVars.count == outputs.count {
                state = .header(inputVars: inputVars, outputVars: outputVars)
            }
            else {
                state = .error(message: "error parsing line \(line). Input vars: \(inputVars), output vars: \(outputVars)")
            }
            
        case .header(_, _):
            state = .separator
            // TODO: Separator validation (all dashes)
        case .separator:
            state = .content
            // TODO: Content validation
        case .content:
            break
        case .error(_):
            break
        }
        return state
    }
    
    func parseTableFinished() {
        state = .outside
        // TODO: Complete table data
    }
    
    func getInputsOutputs(line: String) -> ([String], [String]) {
        
        var components = (line as NSString).components(separatedBy: "|").map {
            return ($0 as NSString).trimmingCharacters(in: CharacterSet.whitespaces)
        }
        components.removeFirst()
        components.removeLast()
        var inputs: [String] = []
        var outputs: [String] = []
        if let ioSeparatorIndex = components.index(of: "") {
            // [ i, |, o ]. separator = 1
            inputs = Array(components.dropLast(components.count - ioSeparatorIndex))
            outputs = Array(components.dropFirst(ioSeparatorIndex + 1))
        }
        else {
            outputs = components
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
}
