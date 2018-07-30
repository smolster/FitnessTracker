//
//  Diffable.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/23/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation

internal protocol Diffable {
    associatedtype Change
    func differences(to other: Self) -> [Change]
}
