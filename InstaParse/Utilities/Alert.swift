//
//  Alert.swift
//  InstaParse
//
//  Created by hybrayhem.
//

import UIKit

struct Alert {
    private var viewControllerToPresent: UIViewController?
    
    init(_ viewControllerToPresent: UIViewController?) {
        self.viewControllerToPresent = viewControllerToPresent
    }
    
    func showError(description: String? = nil) {
        let alertController = UIAlertController(title: "Oops...", message: "\(description ?? "Please try again...")", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        viewControllerToPresent?.present(alertController, animated: true)
    }
    
    func showError(for error: Error) {
        showError(description: error.localizedDescription)
    }
}
