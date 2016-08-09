# AcceptanceMark

AcceptanceMark is a tool for running Acceptance Tests in Xcode, inspired by [Fitnesse](http://fitnesse.org/).

### Fitnesse advantages

* Easy to write business rules in tabular form in Markdown files.
* All shareholders can write Fitnesse tests.
* Convenient Test Report.

### Fitnesse disadvantages

* Does not integrate well with XCTest.
* Requires to run a separate server.
* Difficult to configure and run locally / on CI.

### The solution: AcceptanceMark

AcceptanceMark is the perfect tool to write acceptance tests a-la Fitnesse, while integrating seamlessly with XCTest.

* Write tests in markdown with tables.
* Auto-generated XCTest boilerplate code for tests with **strong-typed input/outputs**.
* Easy to integrate with both Unit Tests and UI Tests.

### How does this work?

Write your own test sets, like so:

```
image-tests.md

## Image Loading

| name:String   || loaded:Bool  |
| ------------- || ------------ |
| available.png || true         |
| missing.png   || false        |
```

Run AcceptanceMark as an XCode pre-compilation phase, which generates all the required test harness:

```
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
        let result = try! testRunner.run(input)
        XCTAssertEqual(expected, result)
    }

    func testImageLoading_1() {
        
        let input = ImageTests_ImageLoadingInput(name: "missing.png")
        let expected = ImageTests_ImageLoadingResult(loaded: false)
        let result = try! testRunner.run(input)
        XCTAssertEqual(expected, result)
    }
}

func == (lhs: ImageTests_ImageLoadingResult, rhs: ImageTests_ImageLoadingResult) -> Bool {
    return lhs.loaded == rhs.loaded
}
```

Write your test runner:

```
class ImageTests_ImageLoadingTestRunner: ImageTests_ImageLoadingTestRunnable {

    func run(input: ImageTests_ImageLoadingInput) throws -> ImageTests_ImageLoadingResult {
        // Your business logic here
        return ImageTests_ImageLoadingResult(loaded: true)
    }
}
```
