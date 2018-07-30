//
//  Environment.swift
//  FitnessTrackerRx
//
//  Created by Swain Molster on 7/29/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import FitnessTrackerKit

/// The current `Environment`.
internal let Current: Environment = .default

internal struct Environment {
    let service: APIServiceType
}

extension Environment {
    static internal let `default` = Environment(service: APIService())
}
