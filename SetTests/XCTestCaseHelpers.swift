//
//  XCTestCaseHelpers.swift
//  SetTests
//
//  Copyright © 2019 Jihan. All rights reserved.
//

import XCTest
import RxSwift
import RxTest

extension XCTestCase {
    func wait(milliseconds: Int) {
        let waitExpectation = expectation(description: "Wait for \(milliseconds) milliseconds")
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(milliseconds), execute: {
            waitExpectation.fulfill()
        })
        waitForExpectations(timeout: TimeInterval(milliseconds)/1000, handler: nil)
    }
}

protocol RxMock: class {
    var scheduler: TestScheduler { get set }
}

extension RxMock {
//    func mockObservableValue<T, U>(_ property: ReferenceWritableKeyPath<Self, T>, values: [(TestTime, U)]) where T: Observable<U> {
//        self.scheduler = TestScheduler(initialClock: 0)
//        self[keyPath: property] = scheduler.createHotObservable(values.map({ return Recorded.next($0, $1) })).asObservable()
//    }

    func mockObservableEvents<T>(_ property: inout Observable<T>, events: [(TestTime, T)]) {
        property = scheduler.createHotObservable(events.map({ Recorded.next($0, $1) })).asObservable()
    }
}

extension TestScheduler {
    func createNonTerminatingHotObservable<T>(events: [(TestTime, T)]) -> Observable<T> {
        return createHotObservable(events.map({ Recorded.next($0, $1) })).asObservable()
    }
}
