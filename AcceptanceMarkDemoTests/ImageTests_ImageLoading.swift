//
//  _FITImageLoadingTests.swift
//  FitMark
//
//  Created by Andrea Bizzotto on 29/06/2016.
//  Copyright © 2016 musevisions. All rights reserved.
//
// Auto Generated

import UIKit
import XCTest
import AcceptanceMark


/*
 * image-tests.md
 *
 * ## Image Loading
 *
 * | name:String  || loaded:Bool  |
 * | ------------ || ------------ |
 * | close.png    || true         |
 * | missing.png  || false        |
 *
 */

struct ImageTests_ImageLoadingInput {
    let name: String
}

struct ImageTests_ImageLoadingResult: Equatable {
    let loaded: Bool
}

protocol ImageTests_ImageLoadingTestRunnable {
    func run(input: ImageTests_ImageLoadingInput) throws -> ImageTests_ImageLoadingResult
}


class ImageTests_ImageLoadingTests: XCTestCase {

    var testRunner: ImageTests_ImageLoadingTestRunnable!
    
    override func setUp() {
        testRunner = ImageTests_ImageLoadingTestRunner()
    }
    
    func testImageLoading_0() {
        
        let input = try! parseInput(row: 0)
        let expected = try! parseOutput(row: 0)
        let result = try! testRunner.run(input: input)
        XCTAssertEqual(expected, result)
    }

    func testImageLoading_1() {
        
        let input = try! parseInput(row: 1)
        let expected = try! parseOutput(row: 1)
        let result = try! testRunner.run(input: input)
        XCTAssertEqual(expected, result)
    }

    private func parseInput(row: Int) throws -> ImageTests_ImageLoadingInput {
        return ImageTests_ImageLoadingInput(name: "test") // TODO: Parse
    }
    private func parseOutput(row: Int) throws -> ImageTests_ImageLoadingResult {
        return ImageTests_ImageLoadingResult(loaded: true) // TODO: Parse
    }
}

func == (lhs: ImageTests_ImageLoadingResult, rhs: ImageTests_ImageLoadingResult) -> Bool {
    return lhs.loaded == rhs.loaded
}


/*
 * ## URL Resolution
 *
 * | baseURL:String             | name:String  || url          |
 * | -------------------------- | ------------ || ------------ |
 * | http://api.company.com/v1/ | close.png    || http://api.company.com/v1/close.png |
 *
 */

