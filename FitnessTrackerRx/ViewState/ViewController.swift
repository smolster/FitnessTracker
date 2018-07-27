//
//  ViewController.swift
//  FitnessTracker
//
//  Created by Swain Molster on 7/23/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import UIKit
import FitnessTrackerKit

public enum ViewController: Int, CoreState {
    
    case mealEntryRoot
    case allMealsRoot
    case todayRoot
    case settingsRoot
    
    internal func create() -> UIViewController {
        return self.viewControllerType.init()
    }
    
    internal var viewControllerType: UIViewController.Type {
        switch self {
        case .mealEntryRoot:    return MealEntryViewController.self
        case .allMealsRoot:     return AllMealsViewController.self
        case .todayRoot:        return UIViewController.self
        case .settingsRoot:     return UIViewController.self
//        case .recipeCreation:
//            return RecipeCreationViewController.self
        }
    }
}

// Only conditionally conforming because I know that Arrays of `ViewController`s will be small, and this implementation is NOT very performant.
extension Array: Diffable where Element == ViewController {
    
    public enum Change {
        case insertedElementsAtIndices([(Element, Index)])
        case removedElementsAtIndices([(Element, Index)])
    }
    
    public func differences(to other: [Element]) -> [Change] {
        guard self != other else {
            return []
        }
        
        let oldSet = Set(self)
        let newSet = Set(other)
        
        let additions = newSet.subtracting(oldSet)
        let subtractions = oldSet.subtracting(newSet)
        
        if !additions.isEmpty {
            // `ViewController`s were added
            var insertions: [(Element, Index)] = []
            
            for item in additions {
                insertions.append((item, other.index(of: item)!))
            }
            
            return [.insertedElementsAtIndices(insertions)]
        } else {
            // `ViewController`s were removed.
            var removals: [(Element, Index)] = []
            
            for item in subtractions {
                removals.append((item, self.index(of: item)!))
            }
            
            return [.removedElementsAtIndices(removals)]
        }
    }
}

