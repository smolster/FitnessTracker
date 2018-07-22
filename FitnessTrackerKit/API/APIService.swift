//
//  APIService.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/18/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import ReactiveSwift
import Realm
import RealmSwift
import Result

/**
 Dispatches the `action` on global `DispatchQueue`, using the default configuration.
 
 - parameter action: The action to dispatch.
 */
private func randomBackgroundDispatch(_ action: @escaping () -> Void) {
    DispatchQueue.global().async(execute: action)
}

public final class APIService: APIServiceType {
    
    public init() { }
    
    public func add(ingredient: Ingredient) -> SignalProducer<Void, NoError> {
        return .init { signal, _ in
            dispatchToRealm { realm in
                do {
                    try realm.write {
                        realm.add(IngredientObject(ingredient: ingredient))
                    }
                    randomBackgroundDispatch {
                        signal.sendAndComplete(with: ())
                    }
                } catch {
                    
                }
            }
        }
    }
    
    public func getAllIngredients() -> SignalProducer<[Ingredient], NoError> {
        return .init { signal, _ in
            dispatchToRealm { realm in
                let ingredients: [Ingredient] = realm.objects(IngredientObject.self).map { $0.makeIngredient() }
                randomBackgroundDispatch {
                    signal.sendAndComplete(with: ingredients)
                }
            }
        }
    }
    
    
    public func add(mealEntry: Meal) -> SignalProducer<Void, NoError> {
        return .init { signal, _ in
            dispatchToRealm { realm in
                do {
                    try realm.write {
                        realm.add(MealObject(meal: mealEntry))
                    }
                    randomBackgroundDispatch {
                        signal.sendAndComplete(with: ())
                    }
                } catch {
                    
                }
            }
        }
    }
    
    public func getAllMealsByDay(in timeZone: TimeZone) -> SignalProducer<[Day], NoError> {
        return .init { signal, _ in
            dispatchToRealm { realm in
                let days: [Day] = APIOptimizationFunctions.days(from: realm.objects(MealObject.self), using: timeZone)
                randomBackgroundDispatch {
                    signal.sendAndComplete(with: days)
                }
            }
        }
    }
    
    public func getAllMealEntries() -> SignalProducer<[Meal], NoError> {
        return .init { signal, _ in
            dispatchToRealm { realm in
                let meals: [Meal] = realm.objects(MealObject.self).map { $0.makeMeal() }
                randomBackgroundDispatch {
                    signal.sendAndComplete(with: meals)
                }
            }
        }
    }
    
    public func add(recipe: Recipe) -> SignalProducer<Void, NoError> {
        return .init { signal, _ in
            dispatchToRealm { realm in
                do {
                    try realm.write {
                        realm.add(RecipeObject(recipe: recipe))
                    }
                    randomBackgroundDispatch {
                        signal.sendAndComplete(with: ())
                    }
                } catch {
                    
                }
            }
        }
    }
    
    public func getAllRecipes() -> SignalProducer<[Recipe], NoError> {
        return .init { signal, _ in
            dispatchToRealm { realm in
                let recipes: [Recipe] = realm.objects(RecipeObject.self).map { $0.makeRecipe() }
                randomBackgroundDispatch {
                    signal.sendAndComplete(with: recipes)
                }
            }
        }
    }
    
}

extension Signal.Observer {
    func sendAndComplete(with value: Value) {
        send(value: value)
        sendCompleted()
    }
}
