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
        APIManager().logOutUser { result in
            switch result {

            case .success:
                // Set root to login screen
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: Constants.storyboardIdentifier, bundle: nil)
                    let viewController = storyboard.instantiateViewController(withIdentifier: Constants.loginNavigationControllerIdentifier)
                    window?.rootViewController = viewController
                }
            
            case .failure(let error):
                print("❌ Log out error: \(error)")
            }

        }
    }
}
