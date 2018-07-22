//
//  View.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 5/8/18.
//  Copyright © 2018 Daymaker, Inc. All rights reserved.
//

public protocol View {
    associatedtype ViewModel
    func configure(with viewModel: ViewModel)
}

public extension View {
    public func configured(with viewModel: ViewModel) -> Self {
        self.configure(with: viewModel)
        return self
    }
}
