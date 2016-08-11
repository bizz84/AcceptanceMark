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
    }
    
    struct Variable {
        let name: String
        let type: VariableType
    }
    
    struct TestData {
        let inputs: [ Any ]
        let outputs: [ Any ]
    }
    
    var inputs: [ Variable ] = []
    var outputs: [ Variable ] = []
    
    var tests: [ TestData ] = []
}

extension TestSpec: CustomDebugStringConvertible {
    
    var debugDescription: String {
        return "fileName: \(fileName)\ntitle: \(title)\n"
    }
}
