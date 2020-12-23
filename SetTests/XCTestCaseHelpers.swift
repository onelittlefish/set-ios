//
//  XCTestCaseHelpers.swift
//  SetTests
//
//  Copyright © 2019 Jihan. All rights reserved.
//

import XCTest

extension XCTestCase {
    func wait(milliseconds: Int) {
        let waitExpectation = expectation(description: "Wait for \(milliseconds) milliseconds")
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(milliseconds), execute: {
            waitExpectation.fulfill()
        })
        waitForExpectations(timeout: TimeInterval(milliseconds)/1000, handler: nil)
    }
}
