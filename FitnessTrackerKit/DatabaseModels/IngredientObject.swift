//
//  IngredientObject.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/22/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import RealmSwift

internal class IngredientObject: Object {
    @objc dynamic private var proteinGrams: Int = 0
    @objc dynamic private var carbsGrams: Int = 0
    @objc dynamic private var fatGrams: Int = 0
    
    @objc dynamic private var name: String = ""
    
    private var macros: Macros {
        get {
            return .init(
                protein: .init(rawValue: proteinGrams),
                carbs: .init(rawValue: carbsGrams),
                fat: .init(rawValue: fatGrams)
            )
        }
        
        set {
            self.proteinGrams = newValue.protein.rawValue
            self.carbsGrams = newValue.carbs.rawValue
            self.fatGrams = newValue.fat.rawValue
        }
    }
    
    convenience init(name: String, macros: Macros) {
        self.init()
        self.name = name
        self.macros = macros
    }
}

extension IngredientObject {
    func makeIngredient() -> Ingredient {
        return .init(name: self.name, macros: self.macros)
    }
}
