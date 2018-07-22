//
//  Macros.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/20/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation

public struct Macros {
    var protein: Grams
    var carbs: Grams
    var fat: Grams
    
    public init(protein: Grams, carbs: Grams, fat: Grams) {
        self.protein = protein
        self.carbs = carbs
        self.fat = fat
    }
    
    static var zero: Macros {
        return .init(protein: 0, carbs: 0, fat: 0)
    }
}
