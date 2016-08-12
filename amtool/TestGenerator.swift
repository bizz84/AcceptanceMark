//
//  TestGenerator.swift
//  AcceptanceMark
//
//  Created by Andrea Bizzotto on 12/08/2016.
//  Copyright © 2016 musevisions. All rights reserved.
//

import Cocoa

class TestGenerator: NSObject {

    class func generateTests(testSpecs: [TestSpec], outputDir: String) {
        
        for testSpec in testSpecs {
            generateTests(testSpec: testSpec, outputDir: outputDir)
        }
        
    }
    
    class func generateTests(testSpec: TestSpec, outputDir: String) {
        
        // Header
        var source: String = ""
        source.append(
            "/*\n" +
            " * File Auto-Generated by AcceptanceMark - DO NOT EDIT\n" +
            " * input file: \(testSpec.fileName)\n" +
            " * generated file: \(testSpec.sourceFileName)\n" +
            " *\n" +
            " */\n") // TODO: Add input test.md

        // Imports
        source.append(
            "import XCTest\n" +
            "import AcceptanceMark\n" +
            "\n")
        
        // Input struct
        var testInputs: String = ""
        for inputVar in testSpec.inputVars {
            testInputs.append("\tlet \(inputVar.name): \(inputVar.type.rawValue)\n")
        }
        
        let testClassIdentifier = "\(testSpec.namespace)_\(testSpec.testName)"
        let inputStructName = "\(testClassIdentifier)Input"
        source.append(
            "struct \(inputStructName) {\n" +
            testInputs +
            "}\n\n")
        
        // Output struct
        var testOutputs: String = ""
        for outputVar in testSpec.outputVars {
            testOutputs.append("\tlet \(outputVar.name): \(outputVar.type.rawValue)\n")
        }
        
        let outputStructName = "\(testClassIdentifier)Output"
        source.append(
            "struct \(outputStructName) {\n" +
                testOutputs +
            "}\n\n")

        // Runnable protocol
        source.append(
            "protocol \(testClassIdentifier)Runnable {\n" +
            "\tfunc run(input: \(inputStructName)) throws -> \(outputStructName)\n" +
            "}\n")

        // TODO: All tests
        
        // XCTestCase class
        source.append(
            "class \(testClassIdentifier)Tests: XCTestCase {\n" +
            "\n" +
            "\tvar testRunner: \(testClassIdentifier)Runnable!\n" +
            "\n" +
            "\toverride func setUp() {\n" +
            "\t\t// MARK: Implement the \(testClassIdentifier)TestRunner() class!\n" +
            "\t\ttestRunner = \(testClassIdentifier)Runner()\n" +
            "\t}\n" +
            "}\n"
        )
        
        print("\(source)")
    }
}