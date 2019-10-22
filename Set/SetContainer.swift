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
            container.register(GameManagerProtocol.self) { _ in
                return GameManager()
            }.inObjectScope(.container)
        }
        return container
    }
}
