//
//  Coordinator.swift
//  MVVMRxSwiftLoginTutorial
//
//  Created by KIM Hyung Jun on 10/30/23.
//

import UIKit

class Coordinator {
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let rootViewController = RootViewController()
        let navigationRootViewController = UINavigationController(rootViewController: rootViewController)
        window.rootViewController = navigationRootViewController
        window.makeKeyAndVisible()
    }
}
