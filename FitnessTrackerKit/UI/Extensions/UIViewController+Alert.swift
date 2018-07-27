//
//  UIViewController+Alert.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/26/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import UIKit

public extension UIAlertAction {
    static func ok(_ handler: ((UIAlertAction) -> Void)?) -> UIAlertAction {
        return UIAlertAction(title: "OK", style: .default, handler: handler)
    }
}

public extension UIViewController {
    
    @discardableResult
    public func showAlert(title: String? = nil, message: String?, buttons: [UIAlertAction], presentationCompletion: (() -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        buttons.forEach(alert.addAction(_:))
        self.present(alert, animated: true, completion: presentationCompletion)
        return alert
    }
}
