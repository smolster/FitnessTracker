//
//  Macros.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/20/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation

public struct Macros: Codable {
    var protein: Grams
    var carbs: Grams
    var fat: Grams
    
    static var zero: Macros {
        return .init(protein: 0, carbs: 0, fat: 0)
    }
}
