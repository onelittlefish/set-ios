//
//  SetAppDelegate.swift
//  Set
//
//  Copyright (c) 2019 Jihan. All rights reserved.
//

import Foundation
import UIKit
import Swinject

@UIApplicationMain
class SetAppDelegate: UIResponder, UIApplicationDelegate {
    private(set) var container: Container!

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        container = SetContainer.createContainer()
        return true
    }
}
