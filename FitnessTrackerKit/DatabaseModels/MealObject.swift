//
//  MealObject.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/18/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import RealmSwift

internal class MealObject: RealmSwift.Object {
    
    @objc dynamic private var id: String = UUID().uuidString
    
    /// time interval since 1970
    @objc dynamic private var dateOfMeal: Double = 0.0
    
    private let componentsAndAmounts = List<MealObjectComponentAndAmount>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    internal var date: Date {
        return Date(timeIntervalSince1970: dateOfMeal)
    }
    
    internal static func create(in realm: Realm, entryDate: Date, componentsAndAmounts: [Meal.ComponentAndAmount]) -> MealObject {
        let object = realm.create(MealObject.self)
        object.dateOfMeal = entryDate.timeIntervalSince1970
        componentsAndAmounts.forEach { componentAndAmount in
            object.componentsAndAmounts.append(.create(in: realm, componentAndAmount))
        }
        return object
    }
    
    convenience init(using realm: Realm, meal: Meal) {
        self.init()
        self.dateOfMeal = meal.entryDate.timeIntervalSince1970
        
        meal.componentsAndAmounts.forEach { componentAndAmount in
            self.componentsAndAmounts.append(.create(in: realm, componentAndAmount))
        }
    }
    
    internal func makeMeal() -> Meal {
        return .init(
            id: .init(rawValue: self.id),
            entryDate: self.date,
            componentsAndAmounts: self.componentsAndAmounts.map { $0.makeComponentAndAmount() }
        )
    }
}

internal class MealObjectComponentAndAmount: RealmSwift.Object {
    
    @objc dynamic private var ingredient: IngredientObject? = nil
    @objc dynamic private var recipe: RecipeObject? = nil
    @objc dynamic private var amount: Int = 0
    
    fileprivate static func create(in realm: Realm, _ componentAndAmount: Meal.ComponentAndAmount) -> MealObjectComponentAndAmount {
        let object = realm.create(MealObjectComponentAndAmount.self)
        switch componentAndAmount.component {
        case .recipe(let recipe):
            object.recipe = realm.object(ofType: RecipeObject.self, forPrimaryKey: recipe.id.rawValue)
        case .ingredient(let ingredient):
            object.ingredient = realm.object(ofType: IngredientObject.self, forPrimaryKey: ingredient.id.rawValue)
        }
        object.amount = componentAndAmount.amount.rawValue
        return object
    }
    
    fileprivate func makeComponentAndAmount() -> Meal.ComponentAndAmount {
        let component: Meal.Component
        if let recipeObj = self.recipe {
            component = .recipe(recipeObj.makeRecipe())
        } else {
            component = .ingredient(self.ingredient!.makeIngredient())
        }
        return .init(component: component, amount: .init(rawValue: self.amount))
    }
    
}
