//
//  main.swift
//  amtool
//
//  Created by Andrea Bizzotto on 09/08/2016.
//  Copyright © 2016 musevisions. All rights reserved.
//

import Foundation

let arguments = Arguments(arguments: Process.arguments)

guard let inputFilePath = arguments.inputFilePath else {
    print("missing input file. Syntax:\namtool -i <input-file.md>")
    exit(0)
}

if !FileManager.default.fileExists(atPath: inputFilePath) {
    print("Could not find file at path: \(inputFilePath)")
    exit(0)
}

switch MarkdownDocumentParser.parse(inputFilePath: inputFilePath) {
case .error(let message):
    print(message)
    exit(0)
case .success(let testSpecs):
    print(testSpecs)
}
