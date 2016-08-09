//
//  ImageTests_ImageLoadingTests.swift
//  AcceptanceMark
//
//  Auto Generated file - DO NOT EDIT
//  Copyright © 2016 musevisions. All rights reserved.
//

import UIKit
import XCTest
import AcceptanceMark


/*
 * image-tests.md
 *
 * ## Image Loading
 *
 * | name:String   || loaded:Bool  |
 * | ------------- || ------------ |
 * | available.png || true         |
 * | missing.png   || false        |
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
        // MARK: Implement the ImageTests_ImageLoadingTestRunner() class!
        testRunner = ImageTests_ImageLoadingTestRunner()
    }
    
    func testImageLoading_0() {
        
        let input = ImageTests_ImageLoadingInput(name: "available.png")
        let expected = ImageTests_ImageLoadingResult(loaded: true)
        let result = try! testRunner.run(input: input)
        XCTAssertEqual(expected, result)
    }
    
    func testImageLoading_1() {
        
        let input = ImageTests_ImageLoadingInput(name: "missing.png")
        let expected = ImageTests_ImageLoadingResult(loaded: false)
        let result = try! testRunner.run(input: input)
        XCTAssertEqual(expected, result)
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

