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
    
    enum VariableType {
        case bool
        case int
        case float
        case string
        case unknown
        
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
    
    struct Variable {
        let name: String
        let type: VariableType
    }
    
    struct TestData {
        let inputs: [ Any ]
        let outputs: [ Any ]
    }
    
    var inputVars: [ Variable ] = []
    var outputVars: [ Variable ] = []
    
    var tests: [ TestData ] = []
}

extension TestSpec: CustomDebugStringConvertible {
    
    var debugDescription: String {
        return "fileName: \(fileName)\ntitle: \(title)\n"
    }
}
