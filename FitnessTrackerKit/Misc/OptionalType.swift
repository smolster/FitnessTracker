//
//  OptionalType.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/25/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation

public protocol OptionalType {
    associatedtype WrappedValue
    var isNil: Bool { get }
    var asOptional: WrappedValue? { get }
}

extension Optional: OptionalType {
    public typealias WrappedValue = Wrapped
    
    public var isNil: Bool {
        return self == nil
    }
    
    public var asOptional: Wrapped? {
        return self
    }
}
