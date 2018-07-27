//
//  IngredientObject.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/22/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import RealmSwift

internal class IngredientObject: RealmSwift.Object {
    
    @objc dynamic private var id: String = UUID().uuidString
    
    @objc dynamic private var proteinGrams: Int = 0
    @objc dynamic private var carbsGrams: Int = 0
    @objc dynamic private var fatGrams: Int = 0
    
    @objc dynamic private var name: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
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
    
    public static func create(in realm: Realm, name: String, macros: MacroCount) -> IngredientObject {
        let object = realm.create(IngredientObject.self)
        object.name = name
        object.macrosIn100g = macros
        return object
    }
    
    internal func makeIngredient() -> Ingredient {
        return .init(id: .init(rawValue: self.id), name: self.name, macrosIn100g: self.macrosIn100g)
    }
}
