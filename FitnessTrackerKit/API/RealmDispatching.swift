//
//  RealmDispatching.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/22/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import RealmSwift

private let realmQueue = DispatchQueue(label: "com.smolster.FitnessTrackerKit.realm")

/**
 Safely dispatches the `action` onto our `Realm` queue.
 
 - Note: as of 7/22/2018, only write actions need to be safely dispatched. However, I have decided to take the approach of simply dispatching every action to this queue. This will simplify interactions with the `Realm`, and will also ensure that any retrieved data is the most up-to-date.
 
 - Parameters:
    - action: The action to perform.
    - realm: Our `Realm` instance.
*/
internal func dispatchToRealm(_ action: @escaping (_ realm: Realm) -> Void) {
    realmQueue.async {
        let realm = try! Realm()
        action(realm)
    }
}
