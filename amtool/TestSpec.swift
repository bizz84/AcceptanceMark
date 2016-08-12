//
//  TestSpec.swift
//  AcceptanceMark
//
//  Created by Andrea Bizzotto on 11/08/2016.
//  Copyright © 2016 musevisions. All rights reserved.
//

struct TestSpec {
    var fileName: String = ""
    var title: String = ""
    
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
