//
//  NonpersistentContainer.swift
//  FitnessTrackerReSwift
//
//  Created by Swain Molster on 7/31/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation

/// A `Codable` container that will never encode its wrapped value.
public struct NonpersistentContainer<T>: Codable {
    public var value: T?
    public init(_ value: T?) {
        self.value = value
    }
    
    public init(from decoder: Decoder) throws {
        self.init(nil)
    }
    
    public func encode(to encoder: Encoder) throws {
        
    }
}
