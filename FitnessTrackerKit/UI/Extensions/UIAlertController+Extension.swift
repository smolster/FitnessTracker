//
//  UIAlertController+Extension.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/23/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

public extension UIAlertController {
    public static func textEntry(
        message: String,
        keyboardType: UIKeyboardType,
        textIsValid: @escaping (String) -> Bool = { _ in return true },
        doneActionBlock: ((UIAlertController, String) -> Void)? = nil
    ) -> UIAlertController {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "Done", style: .default) { [unowned alertController] _ in
            doneActionBlock?(alertController, alertController.textFields!.first!.text ?? "")
        }
        alertController.addAction(doneAction)
        
        alertController.addTextField { textField in
            textField.reactive
                .continuousTextValues
                .mapNilToEmpty
                .observeValues { [unowned doneAction] string in
                    doneAction.isEnabled = textIsValid(string)
                }
        }
        
        return alertController
    }
}
