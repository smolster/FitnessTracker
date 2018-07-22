//
//  Ingredient.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/20/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation

public struct Ingredient {
    public let name: String
    
    public let macros: Macros
    
    public init(name: String, macros: Macros) {
        self.name = name
        self.macros = macros
    }
}
