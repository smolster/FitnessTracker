//
//  ReduxProtocols.swift
//  FitnessTrackerReSwift
//
//  Created by Swain Molster on 7/30/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import RxSwift

public protocol Action { }

public typealias Reducer<State> = (Action, State) -> State

public typealias Middleware = (Action) -> Void

public class Store<State> {
    private let queue: DispatchQueue
    private let _publishSubject: PublishSubject<State>
    private var _state: State
    private let reducer: Reducer<State>
    private let middlewares: [Middleware]
    
    public var observable: Observable<State> { return _publishSubject.asObservable() }
    
    public var state: State { return self._state }
    
    public init(
        initialValue: State,
        queueLabel: String = "Store Queue",
        reducer: @escaping Reducer<State>,
        middlewares: [Middleware]
    ) {
        self.queue = DispatchQueue(label: queueLabel)
        self._publishSubject = PublishSubject<State>()
        self._state = initialValue
        self.reducer = reducer
        self.middlewares = middlewares
    }
    
    /// Dispatches an `action` to the store.
    public func dispatch(_ action: Action) {
        queue.async { [unowned self] in
            self.middlewares.forEach { $0(action) }
            
            self._state = self.reducer(action, self._state)
            self._publishSubject.onNext(self._state)
        }
    }
}
