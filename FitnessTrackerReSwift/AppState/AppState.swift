//
//  AppState.swift
//  FitnessTrackerReSwift
//
//  Created by Swain Molster on 7/23/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import FitnessTrackerKit

internal struct AppState: CoreState {
    var viewState: ViewState
    
    var allMeals: Resource<[Meal]>
    var allIngredients: Resource<[Ingredient]>
    var allRecipes: Resource<[Recipe]>
    var allMealsByDay: Resource<[Day]>
    
//    var ingredientEntryState:
}

extension AppState: HasInitial {
    internal static var initial: AppState {
        return AppState(
            viewState: .initial,
            allMeals: .notQueried,
            allIngredients: .notQueried,
            allRecipes: .notQueried,
            allMealsByDay: .notQueried
        )
    }
}
