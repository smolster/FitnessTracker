//
//  Reusable.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/21/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import UIKit

public enum ReuseKind {
    case nib
    case `class`
}

public protocol Reusable {
    static var reuseKind: ReuseKind { get }
}

public extension Reusable where Self: UITableViewCell {
    public static var reuseKind: ReuseKind { return .class }
}

public extension Reusable where Self: UICollectionViewCell {
    public static var reuseKind: ReuseKind { return .class }
}

extension UITableViewCell: Reusable { }
extension UICollectionViewCell: Reusable { }
