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
    
    private var macrosIn100g: MacroCount {
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
    
    convenience init(ingredient: Ingredient) {
        self.init()
        self.name = ingredient.name
        self.macrosIn100g = ingredient.macrosIn100g
    }
}

extension IngredientObject {
    func makeIngredient() -> Ingredient {
        return .init(name: self.name, macrosIn100g: self.macrosIn100g)
    }
}
