/*
 Copyright (c) 2016 Andrea Bizzotto bizz84@gmail.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import Foundation

let version = "0.2.3"

let arguments = Arguments(arguments: ProcessInfo.processInfo.arguments)

if arguments.printVersion {
    print("amtool version \(version)")
    exit(0)
}

guard let inputFilePath = arguments.inputFilePath else {
    print("missing input file. Syntax:\namtool -i <input-file.md> [-l swift2|swift3]")
    exit(0)
}

if !FileManager.default.fileExists(atPath: inputFilePath) {
    print("Could not find file at path: \(inputFilePath)")
    exit(0)
}

guard let data = FileManager.default.contents(atPath: inputFilePath) else {
    print("Invalid file contents at path: \(inputFilePath)")
    exit(0)
}

guard let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String? else {
    print("Could not decode file contents at path: \(inputFilePath)")
    exit(0)
}

let parser = MarkdownDocumentParser()
let result = parser.parse(fileContents: string, inputFilePath: inputFilePath)

//print(result.testSpecs)

let outputDir = (inputFilePath as NSString).deletingLastPathComponent
TestGenerator.generateTests(testSpecs: result.testSpecs, outputDir: outputDir, language: arguments.language)
