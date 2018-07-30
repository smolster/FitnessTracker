//
//  Route.swift
//  FitnessTrackerReSwift
//
//  Created by Swain Molster on 7/27/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import UIKit

internal enum Route {
    
    case today
    
    internal init?(path: URL) {
        return nil
    }
    
    internal init(shortcutItem: UIApplicationShortcutItem) {
        switch shortcutItem.type {
        case "today":   self = .today
        default:        fatalError()
        }
    }
}
