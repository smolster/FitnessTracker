//
//  NibLoadable.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 5/8/18.
//  Copyright © 2018 Daymaker, Inc. All rights reserved.
//

import UIKit

public protocol NibLoadable: class {
    static var nibName: String { get }
}

extension NibLoadable where Self: UIView {
    public static var nibName: String {
        return String(describing: self)
    }
}

extension NibLoadable where Self: UIViewController {
    public static var nibName: String {
        return String(describing: self)
    }
}

extension UIView: NibLoadable { }
extension UIViewController: NibLoadable { }
