//
//  UIViewController+Swizzling.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/23/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import UIKit

private func swizzle(_ vc: UIViewController.Type) {
    [
        (#selector(vc.viewDidLoad), #selector(vc.my_viewDidLoad)),
        (#selector(vc.viewWillDisappear(_:)), #selector(vc.my_viewWillDisappear(_:))),
        (#selector(vc.viewWillAppear(_:)), #selector(vc.my_viewWillAppear(animated:))),
        (#selector(vc.traitCollectionDidChange(_:)), #selector(vc.my_traitCollectionDidChange(_:)))
    ].forEach { original, swizzled in
        guard let originalMethod = class_getInstanceMethod(vc, original),
            let swizzledMethod = class_getInstanceMethod(vc, swizzled) else {
                return
        }
        
        let didAddMethod = class_addMethod(vc,
                                                      original,
                                                      method_getImplementation(swizzledMethod),
                                                      method_getTypeEncoding(swizzledMethod))
        
        if didAddMethod {
            class_replaceMethod(vc,
                                swizzled,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    
}

private var hasSwizzled: Bool = false

extension UIViewController {
    
    final public class func doSwizzling() {
        guard !hasSwizzled else {
            return
        }
        
        hasSwizzled = true
        swizzle(self)
    }
    
    @objc internal func my_viewDidLoad() {
        self.my_viewDidLoad()
    }
    
    @objc internal func my_viewWillAppear(animated: Bool) {
        self.my_viewWillAppear(animated: animated)
        
    }
    
    @objc public func my_traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.my_traitCollectionDidChange(previousTraitCollection)
        
    }
    
    @objc internal func my_viewWillDisappear(_ animated: Bool) {
        self.my_viewWillDisappear(animated)
        
        if let wrappingNav = self.navigationController {
            if wrappingNav.viewControllers.contains(self) == false && !self.isBeingDismissed {
                self.backButtonPressed()
                
                storeDispatchQueue.sync {
                    store.dispatch(NavigationAction.popViewController)
                }
            }
        }
    }
    
    @objc open func backButtonPressed() {
        
    }
    
    
}
