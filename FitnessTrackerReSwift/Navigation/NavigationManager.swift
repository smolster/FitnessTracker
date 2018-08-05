//
//  NavigationManager.swift
//  FitnessTrackerReSwift
//
//  Created by Swain Molster on 7/23/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import UIKit
import FitnessTrackerKit
import RxSwift

/**
 This class subscribes to the `AppState`'s `viewState`, and makes changes to the navigation according to updates.
 */
final internal class NavigationManager {
    
    public static let shared = NavigationManager()
    
    private let disposeBag = DisposeBag()
    internal let rootTabController = RootTabController()
    private var isInitialLoad = true
    private var previousState: ViewState = store.state.viewState

    private init() {
        store.observable
            .map { $0.viewState }
            .subscribeToNext { viewState in
                dispatchToMainIfNeeded { [weak self] in
                    guard let strongSelf = self else { return }
                    if strongSelf.isInitialLoad {
                        strongSelf.render(viewState: viewState)
                        strongSelf.isInitialLoad = false
                    } else {
                        for change in strongSelf.previousState.differences(to: viewState).orderedForRendering() {
                            strongSelf.applyChange(change, animated: true)
                        }
                    }
                    strongSelf.previousState = viewState
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    fileprivate func render(viewState: ViewState) {
        var uiViewControllers: [UIViewController] = []
        
        var topViewControllerOfSelectedTab: UIViewController!
        
        for tab in ViewState.Tab.allCases {
            let viewControllers = viewState.tabStacks[tab]
            let viewController = viewControllers.first!.create()
            let rootNav = UINavigationController(rootViewController: viewController)
            rootNav.tabBarItem = tab.tabBarItem()
            for (i, viewController) in viewControllers.enumerated() where i > 0 {
                rootNav.pushViewController(viewController.create(), animated: false)
            }
            uiViewControllers.append(rootNav)
            
            if tab == viewState.selectedTab {
                topViewControllerOfSelectedTab = rootNav.topViewController!
            }
        }
        
        rootTabController.viewControllers = uiViewControllers
        rootTabController.selectedIndex = viewState.selectedTab.index
        if let modal = viewState.modal {
            switch modal {
            case .single(let viewController):
                topViewControllerOfSelectedTab.present(viewController.create(), animated: true, completion: nil)
            case .stack(let viewControllers):
                let navVC = UINavigationController(rootViewController: viewControllers.first!.create())
                for i in 1..<viewControllers.count {
                    navVC.pushViewController(viewControllers[i].create(), animated: false)
                }
                topViewControllerOfSelectedTab.present(navVC, animated: true, completion: nil)
            }
        }
    }
    
    /// Translates the `change` into imperative action on rendered navigation.
    fileprivate func applyChange(_ change: ViewState.Change, animated: Bool) {
        /**
         Translates the `newStack` into an array of `UIViewController`s. Reuses any view controllers of the same type in the `oldStack`.
         */
        func newViewControllers(newStack: [ViewController], oldStack: [UIViewController]) -> [UIViewController] {
            var newUIStack: [UIViewController?] = newStack.map { _ in nil }
            for (i, vc) in newStack.enumerated() {
                if let alreadyExisting = oldStack.first(where: { type(of: $0) == vc.viewControllerType }) {
                    newUIStack[i] = alreadyExisting
                } else {
                    newUIStack[i] = vc.create()
                }
            }
            return newUIStack.map { $0.unsafelyUnwrapped }
        }
        
        switch change {
        case .switched(fromTab: _, toTab: let newTab):
            rootTabController.selectedIndex = newTab.index
            
        case .tabStacksChanged(let tabsWithVCs):
            for (tab, newStack) in tabsWithVCs {
                let nav = self.navigationController(forTab: tab)
                nav.setViewControllers(newViewControllers(newStack: newStack, oldStack: nav.viewControllers), animated: animated)
            }
            
        case .presentedModal(viewController: let viewController, onTab: let tab):
            self.topViewController(forTab: tab).present(viewController.create(), animated: animated, completion: nil)
        case .presentedModalInNavigationController(viewController: let viewController, onTab: let tab):
            // TODO: Update store in completion block to know presenting finished?
            self.topViewController(forTab: tab).present(UINavigationController(rootViewController: viewController.create()), animated: animated, completion: nil)
        case .dismissedModal(onTab: let tab):
            // Force unwrapped here, because I want to KNOW if this change happens at an invalid time.
            self.topViewController(forTab: tab).presentedViewController!.dismiss(animated: animated, completion: nil)
            
        case .modalStackChanged(let newStack):
            let nav = self.modalNavigationController()!
            nav.setViewControllers(newViewControllers(newStack: newStack, oldStack: nav.viewControllers), animated: animated)
        }
    }
    
    /// Returns the `UINavigationController` wrapping the currently-presented view controller, if it exists.
    fileprivate func modalNavigationController() -> UINavigationController? {
        let presentingViewController = self.topViewController(forTab: store.state.viewState.selectedTab)
        return presentingViewController.presentedViewController as? UINavigationController
    }
    
    /// Returns the base `UINavigationController` associated with the tab.
    fileprivate func navigationController(forTab tab: ViewState.Tab) -> UINavigationController {
        let navigationVCs = rootTabController.viewControllers!.map({ $0 as? UINavigationController }).compactMap({ $0 })
        return navigationVCs[tab.index]
    }
    
    /// Returns the `UIViewController` at the top of the `tab`'s stack.
    fileprivate func topViewController(forTab tab: ViewState.Tab) -> UIViewController {
        let navigationVCs = rootTabController.viewControllers!.map({ $0 as? UINavigationController }).compactMap({ $0 })
        let navigationVC = navigationVCs[tab.index]
        return navigationVC.topViewController!
    }
}

fileprivate extension Array where Element == ViewState.Change {
    /// O(n^2) Sorts the array into the correct order for rendering. The first element should be rendered first, moving forward.
    func orderedForRendering() -> [ViewState.Change] {
        return self.sorted(by: { $0.renderingImportance < $1.renderingImportance })
    }
}
