//
//  ResourceAction.swift
//  FitnessTrackerReSwift
//
//  Created by Swain Molster on 7/27/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation

/**
 A type-erased action for updating a `Resource` in a `State`. This action provides an "application" function to hide the type of the resource.
 */
internal struct ResourceAction<State>: CoreAction {
    
    enum Kind<Model> {
        case beganLoading
        case didError(Error)
        case didLoad(Model)
    }
    
    private let application: (inout State) -> Void
    
    let loggingString: String
    
    /// Applies the resource update to `state`.
    internal func apply(to state: inout State) {
        application(&state)
    }
    
    private init(application: @escaping (inout State) -> Void, loggingString: String) {
        self.application = application
        self.loggingString = loggingString
    }
    
    /**
     Initializes and returns a `ResourceAction` that will update the resource at the provided `keyPath` using the provided update `kind`.
     
     - Parameters:
        - kind: The `Kind` of update this action represents.
        - keyPath: A map to the `Resource` to update.
     */
    internal init<Model>(_ kind: Kind<Model>, keyPath: WritableKeyPath<State, Resource<Model>>) {
        self.application = { state in
            switch kind {
            case .beganLoading:
                state[keyPath: keyPath] = .loading
            case .didLoad(let model):
                state[keyPath: keyPath] = .loaded(model)
            case .didError(let error):
                state[keyPath: keyPath] = .loadFailed(error)
            }
        }
        self.loggingString = "ResourceAction (kind: \(kind), keyPath: \(keyPath)"
    }
}
