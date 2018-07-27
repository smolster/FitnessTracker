//
//  ModalNavigationStack.swift
//  FitnessTrackerReSwift
//
//  Created by Swain Molster on 7/23/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation

internal enum ModalNavigationStack: CoreState {
    case single(ViewController)
    case stack([ViewController])
    
    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        do {
            let vc = try container.decode(ViewController.self)
            self = .single(vc)
        } catch {
            do {
                let vcs = try container.decode([ViewController].self)
                self = .stack(vcs)
            }
        }
    }
    
    internal func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .single(let vc):
            try container.encode(vc)
        case .stack(let vcs):
            try container.encode(vcs)
        }
    }
}

extension ModalNavigationStack {
    func contains(viewController: ViewController) -> Bool {
        switch self {
        case .single(let viewController):
            return viewController == viewController
        case .stack(let stack):
            return stack.contains(viewController)
        }
    }
}
