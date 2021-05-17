//
//  SetAppDelegate.swift
//  Set
//
//  Copyright (c) 2019 Jihan. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import Swinject

@UIApplicationMain
class SetAppDelegate: UIResponder, UIApplicationDelegate {
    private(set) var container: Container!

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        container = SetContainer.createContainer()

        window = UIWindow()
        let rootViewController: UIViewController
        if #available(iOS 14.0, *) {
            rootViewController = UIHostingController(rootView: SetView())
        } else {
            rootViewController = UIStoryboard(name: "SetViewController", bundle: nil).instantiateInitialViewController()!
        }
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()

        return true
    }
}
