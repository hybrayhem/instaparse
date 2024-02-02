//
//  NavigationManager.swift
//  InstaParse
//
//  Created by hybrayhem.
//

import Foundation
import UIKit

struct NavigationManager {
    private enum Constants {
        static let loginNavigationControllerIdentifier = "LoginNavigationController"
        static let feedNavigationControllerIdentifier = "FeedNavigationController"
        static let storyboardIdentifier = "Main"
    }

    func login(window: UIWindow?) {
        let storyboard = UIStoryboard(name: Constants.storyboardIdentifier, bundle: nil)
        window?.rootViewController = storyboard.instantiateViewController(withIdentifier: Constants.feedNavigationControllerIdentifier)
    }

    func logOut(window: UIWindow?) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: Constants.storyboardIdentifier, bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: Constants.loginNavigationControllerIdentifier)
            window?.rootViewController = viewController
        }
    }
}
