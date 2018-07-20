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

func +(_ lhs: Macros, _ rhs: Macros) -> Macros {
    return .init(
        protein: lhs.protein + rhs.protein,
        carbs: lhs.carbs + rhs.carbs,
        fat: lhs.fat + rhs.fat
    )
}

private func backgroundDispatch(_ block: @escaping () -> Void) {
    DispatchQueue(label: "background").async(execute: block)
}


public class APIService {
    
    public init() { }
    
    private var realm: Realm {
        if let realm = Thread.current.threadDictionary["realm"] as? Realm {
            return realm
        } else {
            let realm = try! Realm()
            Thread.current.threadDictionary["realm"] = realm
            return realm
        }
    }
    
    public func addMealEntry(_ meal: Meal) -> SignalProducer<Void, NoError> {
        return SignalProducer<Void, NoError> { signal, _ in
            backgroundDispatch {
                do {
                    try self.realm.write {
                        self.realm.add(
                            MealObject(
                                date: meal.entryDate,
                                proteinGrams: meal.macros.protein.rawValue,
                                fatGrams: meal.macros.fat.rawValue,
                                carbGrams: meal.macros.carbs.rawValue
                            )
                        )
                    }
                    signal.sendAndComplete(with: ())
                } catch {
                    
                }
            }
        }
    }
    
    public func getAllMealsByDay(in timeZone: TimeZone) -> SignalProducer<[Day], NoError> {
        return SignalProducer<[Day], NoError> { signal, _ in
            backgroundDispatch {
                signal.sendAndComplete(with: days(from: self.realm.objects(MealObject.self), using: timeZone))
            }
        }
    }
    
    public func getAllMealEntries() -> SignalProducer<[Meal], NoError> {
        return SignalProducer<[Meal], NoError> { signal, _ in
            backgroundDispatch {
                signal.sendAndComplete(with: self.realm.objects(MealObject.self).map { $0.getMeal() })
            }
        }
    }
}

internal func days<MealObjects: Sequence>(from mealObjects: MealObjects, using timeZone: TimeZone) -> [Day] where MealObjects.Element == MealObject {
    return mealObjects
        .reduce(into: [String: (date: Date, meals: [Meal])]()) { currentDict, mealObj in
            let dateString = DateCacher.shared.string(from: mealObj.date, using: .mmDDYYYY(timeZone))
            if currentDict[dateString] == nil {
                currentDict[dateString] = (mealObj.date, [mealObj.getMeal()])
            } else {
                currentDict[dateString]!.1.append(mealObj.getMeal())
            }
            currentDict[dateString]!.1.sort(by: { $0.entryDate < $1.entryDate })
        }
        .map { pair in
            let (totalCals, totalMacros): (Calories, Macros) =
                pair.value.meals.reduce((Calories.zero, Macros.zero)) { currentCalsAndMacros, meal in
                    return (currentCalsAndMacros.0 + meal.calories, currentCalsAndMacros.1 + meal.macros)
            }
            return Day(date: pair.value.date, totalCalories: totalCals, totalMacros: totalMacros, allMeals: pair.value.meals)
    }
}

extension Signal.Observer {
    func sendAndComplete(with value: Value) {
        send(value: value)
        sendCompleted()
    }
}

private extension MealObject {
    func getMeal() -> Meal {
        return Meal(
            entryDate: self.date,
            macros: Macros(
                protein: .init(rawValue: self.proteinGrams),
                carbs: .init(rawValue: self.carbGrams),
                fat: .init(rawValue: self.fatGrams))
        )
    }
}
