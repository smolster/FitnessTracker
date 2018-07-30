//
//  Current.swift
//  FitnessTrackerReSwift
//
//  Created by Swain Molster on 7/27/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import FitnessTrackerKit

internal let Current: Environment = .default

internal struct Environment {
    let network: NetworkProvider
}

extension Environment {
    static let `default` = Environment(network: NetworkProvider(service: APIService()))
}
