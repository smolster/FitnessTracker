//
//  LoggableAction.swift
//  FitnessTrackerReSwift
//
//  Created by Swain Molster on 7/27/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

internal protocol LoggableAction: Action {
    /// The string to use for logging.
    var loggingString: String { get }
}

extension LoggableAction {
    var loggingString: String {
        return "\(self)"
    }
}
