//
//  SetContainer.swift
//  Set
//
//  Copyright © 2019 Jihan. All rights reserved.
//

import Foundation
import Swinject
import UIKit

class SetContainer {
    static var container: Container {
        // swiftlint:disable:next force_cast
        return (UIApplication.shared.delegate as! SetAppDelegate).container
    }

    static func createContainer() -> Container {
        let container = Container { container in
        container.register(DeckManagerProtocol.self) { _ in
            return DeckManager()
        }.inObjectScope(.container)
            container.register(GameManagerProtocol.self) { resolver in
                return GameManager(
                    deckManager: resolver.resolve(DeckManagerProtocol.self)!
                )
            }.inObjectScope(.container)
        }
        return container
    }
}
