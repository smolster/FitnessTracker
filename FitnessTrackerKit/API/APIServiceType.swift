//
//  APIServiceType.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/18/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

public protocol APIServiceType {
    
    func add(ingredient: Ingredient) -> SignalProducer<Void, NoError>
    
    func getAllIngredients() -> SignalProducer<[Ingredient], NoError>
    
    func add(mealEntry: Meal) -> SignalProducer<Void, NoError>
    
    func getAllMealsByDay(in timeZone: TimeZone) -> SignalProducer<[Day], NoError>
    
    func getAllMealEntries() -> SignalProducer<[Meal], NoError>
    
    func add(recipe: Recipe) -> SignalProducer<Void, NoError>
    
    func getAllRecipes() -> SignalProducer<[Recipe], NoError>
}
