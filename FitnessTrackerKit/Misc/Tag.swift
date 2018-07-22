//
//  Tag.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/18/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation

/// Use for things like IDs associated with types.
public typealias SimpleTag<Tagged, RawValue> = Tag<Tagged, RawValue, Void>

/// Use for things like IDs associated with types. Provide a `Discriminator` type to differentiate Tags with the same `Tagged` and `RawValue`
public struct Tag<Tagged, RawValue, Discriminator> {
    public let rawValue: RawValue
    
    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }
}

extension Tag: Equatable where RawValue: Equatable {
    public static func == (lhs: Tag<Tagged, RawValue, Discriminator>, rhs: Tag<Tagged, RawValue, Discriminator>) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

extension Tag: Encodable where RawValue: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}

extension Tag: Hashable where RawValue: Hashable {
    public var hashValue: Int {
        return rawValue.hashValue
    }
}

extension Tag: Decodable where RawValue: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.rawValue = try container.decode(RawValue.self)
    }
}

extension Tag: ExpressibleByIntegerLiteral where RawValue: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = RawValue.IntegerLiteralType
    
    public init(integerLiteral value: RawValue.IntegerLiteralType) {
        self.rawValue = RawValue(integerLiteral: value)
    }
}

extension Tag: ExpressibleByStringLiteral, ExpressibleByUnicodeScalarLiteral, ExpressibleByExtendedGraphemeClusterLiteral where RawValue: ExpressibleByStringLiteral {
    public typealias ExtendedGraphemeClusterLiteralType = RawValue.ExtendedGraphemeClusterLiteralType
    public typealias UnicodeScalarLiteralType = RawValue.UnicodeScalarLiteralType
    public typealias StringLiteralType = RawValue.StringLiteralType
    
    public init(extendedGraphemeClusterLiteral value: RawValue.ExtendedGraphemeClusterLiteralType) {
        self.rawValue = RawValue(extendedGraphemeClusterLiteral: value)
    }
    
    public init(unicodeScalarLiteral value: RawValue.UnicodeScalarLiteralType) {
        self.rawValue = RawValue(unicodeScalarLiteral: value)
    }
    
    
    public init(stringLiteral value: RawValue.StringLiteralType) {
        self.rawValue = RawValue(stringLiteral: value)
    }
}

extension Tag: ExpressibleByBooleanLiteral where RawValue: ExpressibleByBooleanLiteral {
    public typealias BooleanLiteralType = RawValue.BooleanLiteralType
    
    public init(booleanLiteral value: RawValue.BooleanLiteralType) {
        self.rawValue = RawValue(booleanLiteral: value)
    }
}

extension Tag: CustomStringConvertible where RawValue: CustomStringConvertible {
    public var description: String {
        return rawValue.description
    }
}

extension Tag: CustomDebugStringConvertible where RawValue: CustomDebugStringConvertible {
    public var debugDescription: String {
        return rawValue.debugDescription
    }
}
