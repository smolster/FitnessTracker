//
//  Resource.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/27/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation

/// Represents the state of a loadable asynchronous resource.
public enum Resource<T> {
    
    /// This `Resource` hasn't been queried yet.
    case notQueried
    
    /// This `Resource` is currently loading.
    case loading
    
    /// This `Resource` has been loaded.
    case loaded(T)
    
    /// This `Resource` failed to load.
    case loadFailed(Error)
}

extension Resource {
    public var asLoaded: T? {
        guard case .loaded(let value) = self else { return nil }
        return value
    }
}

private struct SimpleError: Error {
    let localizedDescription: String
    init(_ localizedDescription: String) {
        self.localizedDescription = localizedDescription
    }
}

extension Resource: Equatable where T: Equatable {
    public static func == (lhs: Resource<T>, rhs: Resource<T>) -> Bool {
        switch (lhs, rhs) {
        case (.notQueried, .notQueried):
            return true
        case (.loading, .loading):
            return true
        case (.loaded(let left), .loaded(let right)):
            return left == right
        default:
            return false
        }
    }
}

extension Resource: Decodable where T: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let resource = try? container.decode(T.self) {
            self = .loaded(resource)
        } else {
            let string = try container.decode(String.self)
            
            if string == "notQueried" {
                self = .notQueried
            } else if string == "loading" {
                self = .loading
            } else {
                self = .loadFailed(SimpleError(string.replacingOccurrences(of: "ERROR:", with: "")))
            }
            
        }
    }
}

extension Resource: Encodable where T: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .notQueried:
            try container.encode("notQueried")
        case .loading:
            try container.encode("loading")
        case .loaded(let resource):
            try container.encode(resource)
        case .loadFailed(let error):
            try container.encode("ERROR:\(error.localizedDescription)")
        }
    }
}
