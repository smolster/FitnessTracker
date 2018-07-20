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
    /// time interval since 1970
    @objc dynamic private var dateOfMeal: Double = 0.0
    
    @objc dynamic private(set) var proteinGrams: Int = 0
    @objc dynamic private(set) var fatGrams: Int = 0
    @objc dynamic private(set) var carbGrams: Int = 0
    
    var date: Date {
        return Date(timeIntervalSince1970: dateOfMeal)
    }
    
    convenience init(date: Date, proteinGrams: Int, fatGrams: Int, carbGrams: Int) {
        self.init()
        self.dateOfMeal = date.timeIntervalSince1970
        self.proteinGrams = proteinGrams
        self.fatGrams = fatGrams
    }
}
