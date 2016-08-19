//
//  TestSpec.swift
//  AcceptanceMark
//
//  Created by Andrea Bizzotto on 11/08/2016.
//  Copyright © 2016 musevisions. All rights reserved.
//

import Foundation

struct TestSpec {
    var fileName: String = ""
    var title: String = ""
    var testLines: [String] = []
    
    enum VariableType: String {
        case bool = "Bool"
        case int = "Int"
        case float = "Float"
        case string = "String"
        
        init?(type: String) {
            if type == "Bool" {
                self = .bool
            }
            else if type == "Int" {
                self = .int
            }
            else if type == "Float" {
                self = .float
            }
            else if type == "String" {
                self = .string
            }
            else {
                return nil
            }
        }
    }
    
    struct Variable: CustomDebugStringConvertible {
        let name: String
        let type: VariableType
        var debugDescription: String {
            return "\(name): \(type.rawValue)"
        }
    }
    
    struct TestData: CustomDebugStringConvertible {
        let inputs: [ String ] // Should be Any?
        let outputs: [ String ] // Should be Any?
        var debugDescription: String {
            return "\n          I: \(inputs), O: \(outputs)"
        }
    }
    
    var inputVars: [ Variable ] = []
    var outputVars: [ Variable ] = []
    
    var tests: [ TestData ] = []
}

extension TestSpec: CustomDebugStringConvertible {
    
    var debugDescription: String {
        return "\n  fileName: \(fileName)\n     title: \(title)\n  header I: \(inputVars), O: \(outputVars)\n     tests:\(tests)\n"
    }
}

extension TestSpec {
 
    var namespace: String {
        return (fileName as NSString)
            .replacingOccurrences(of: ".md", with: "")
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: " ", with: "_")
    }
    var testName: String {
        return (title as NSString).replacingOccurrences(of: " ", with: "")
    }
    var sourceFileName: String {
        return "\(namespace)_\(testName).swift"
    }
    
    func inputParametersList(for test:TestData) -> String {
        return parameterList(variables: inputVars, values: test.inputs)
    }
    func outputParametersList(for test:TestData) -> String {
        return parameterList(variables: outputVars, values: test.outputs)
    }
    
    func parameterList(variables: [Variable], values: [String]) -> String {
        
        var index = 0
        var params: [String] = []
        for variable in variables {
            let value = values[index]
            // TODO: formatting checks
            let valueFormatted = variable.type == .string ? "\"" + value + "\"" : value
            params.append("\(variable.name): \(valueFormatted)")
            
            index += 1
        }
        return params.joined(separator: ", ")
    }

}
