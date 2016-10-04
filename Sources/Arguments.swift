/*
Copyright (c) 2016 Andrea Bizzotto bizz84@gmail.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

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
