//
//  Arguments.swift
//  AcceptanceMark
//
//  Created by Andrea Bizzotto on 11/08/2016.
//  Copyright © 2016 musevisions. All rights reserved.
//

import Foundation

enum ArgumentType {
    case value(argument: String)
    case unknown(argument: String)
    case inputFile
    case language
    case printVersion
    
    init(argument: String) {
        
        switch argument {
        case "-i":
            self = .inputFile
        case "-l":
            self = .language
        case "--version":
            self = .printVersion
        default:
            self = argument.characters.first == "-" ? .unknown(argument: argument) : .value(argument: argument)
        }
    }
}

struct Arguments {
    
    let inputFile: String?
    var language: Language = .swift3
    var printVersion: Bool = false
    
    var inputFilePath: String? {
        guard let inputFile = inputFile else {
            return nil
        }
        
        // absolute file path
        let idx = inputFile.index(inputFile.startIndex, offsetBy: 2)
        let firstTwo = inputFile.substring(to: idx)
        if inputFile.characters.first == "/" || firstTwo == "~/" {
            return inputFile
        }
            // relative file path
        else {
            // Current Path
            let currentPath = FileManager.default.currentDirectoryPath
            
            return "\(currentPath)/\(inputFile)"
        }
    }
    
    init(arguments: [String]) {
        
        var inputFile: String?
        var language: Language = .swift3
        var printVersion = false

        var previousArg: ArgumentType?
        for argument in arguments where argument.characters.count > 0 {
            
            let currentArg = ArgumentType(argument: argument)
            if case .printVersion = currentArg {
                printVersion = true
            }
            if let previousArg = previousArg, case .value(let valueArg) = currentArg {
                
                switch previousArg {
                case .inputFile:
                    inputFile = valueArg
                case .language:
                    language = Language(value: valueArg)
                default:
                    break
                }
            }
            previousArg = currentArg
        }
        
        self.inputFile = inputFile
        self.language = language
        self.printVersion = printVersion
    }
}
