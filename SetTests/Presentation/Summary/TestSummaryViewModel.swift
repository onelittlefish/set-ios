//
//  TestSummaryViewModel.swift
//  SetTests
//
//  Copyright © 2019 Jihan. All rights reserved.
//

import XCTest
@testable import Set
import Swinject
import RxTest
import RxSwift
import RxCocoa

class TestSummaryViewModel: XCTestCase {
    private let scheduler = TestScheduler(initialClock: 0)
    private let disposeBag = DisposeBag()

    private var container: Container!

    private var game: MockGameManager!

    private var model: SummaryViewModel!

    override func setUp() {
        game = MockGameManager(scheduler: scheduler)
        container = Container { container in
            container.register(GameManagerProtocol.self) { [unowned self] _ in self.game }
        }
    }

    private func initModel() {
        model = SummaryViewModel(container: container)
    }

    func testStats() {
        game.deck = scheduler.createHotObservable([
            .next(0, Card.allCards()),
            .next(10, [])
        ]).asObservable()

        game.numberOfSetsFound = scheduler.createHotObservable([
            .next(0, 1),
            .next(10, 2)
        ]).asObservable()

        game.numberOfSetsInDeal = scheduler.createHotObservable([
            .next(0, 3),
            .next(10, 4)
        ]).asObservable()

        initModel()

        let stats = scheduler.createObserver([SummaryViewModel.SummaryStat].self)
        model.stats.asDriver(onErrorJustReturn: []).drive(stats).disposed(by: disposeBag)

        scheduler.start()

        let stats1 = stats.events.first?.value.element
        XCTAssertEqual(stats1?[0].label, "Found")
        XCTAssertEqual(stats1?[0].value, "1")
        XCTAssertEqual(stats1?[1].label, "Left")
        XCTAssertEqual(stats1?[1].value, "81")
        XCTAssertEqual(stats1?[2].label, "Sets")
        XCTAssertEqual(stats1?[2].value, "3")

        let stats2 = stats.events.last?.value.element
        XCTAssertEqual(stats2?[0].label, "Found")
        XCTAssertEqual(stats2?[0].value, "2")
        XCTAssertEqual(stats2?[1].label, "Left")
        XCTAssertEqual(stats2?[1].value, "0")
        XCTAssertEqual(stats2?[2].label, "Sets")
        XCTAssertEqual(stats2?[2].value, "4")
    }

}
