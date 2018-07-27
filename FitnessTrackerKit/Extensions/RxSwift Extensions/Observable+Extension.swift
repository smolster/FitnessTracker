//
//  Observable+Extension.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/22/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import RxSwift

public extension Observable where E == String? {
    /// Maps `nil` case to empty `String`.
    public var mapNilToEmpty: Observable<String> {
        return self.map { $0 ?? "" }
    }
}

public extension Observable where E == String {
    public var mapToInt: Observable<Int?> {
        return self.map(Int.init)
    }
}

public extension Observable where E == Int? {
    public var mapNilToZero: Observable<Int> {
        return self.map { $0 ?? 0 }
    }
}

public extension Observable {
    public func mapToVoid() -> Observable<Void> {
        return self.map { _ in return () }
    }
    
    @discardableResult
    public func observeOnUI() -> Observable<E> {
        return self.observeOn(MainScheduler.instance)
    }
    
    public func gather() -> Observable<[E]> {
        return self.scan([E](), accumulator: { return $0 + [$1] })
    }
}


extension Observable where Element: OptionalType {
    public func skipNil() -> Observable<Element.WrappedValue> {
        return self
            .skipWhile { $0.isNil }
            .map { $0.asOptional.unsafelyUnwrapped }
    }
}
