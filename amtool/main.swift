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

if case .error(let message) = MarkdownDocumentParser.parse(inputFilePath: inputFilePath) {
    print(message)
    exit(0)
}

//CMDocumentParser.parse(data: data, inputFilePath: inputFilePath)
