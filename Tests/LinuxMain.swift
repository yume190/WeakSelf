import XCTest

import WeakSelfTests

var tests = [XCTestCaseEntry]()
tests += WeakSelfTests.allTests()
XCTMain(tests)
