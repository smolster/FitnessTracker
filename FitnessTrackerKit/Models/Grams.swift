//
//  Grams.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/18/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation

public enum GramsTag { }
public typealias Grams = SimpleTag<GramsTag, Int>

public func +(_ lhs: Grams, _ rhs: Grams) -> Grams {
    return .init(rawValue: lhs.rawValue + rhs.rawValue)
}
