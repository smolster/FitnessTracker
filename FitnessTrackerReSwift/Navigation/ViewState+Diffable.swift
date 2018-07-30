//
//  ViewState+Diffable.swift
//  FitnessTrackerReSwift
//
//  Created by Swain Molster on 7/23/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import FitnessTrackerKit

extension ViewState: Diffable {
    
    internal enum Change {
        // Tab Switching
        /// The user switched `fromTab`, `toTab`
        case switched(fromTab: Tab, toTab: Tab)
        
        // View controller states changed.
        case tabStacksChanged([(Tab, [ViewController])])
        
        // Modals
        case presentedModal(viewController: ViewController, onTab: Tab)
        case presentedModalInNavigationController(viewController: ViewController, onTab: Tab)
        case dismissedModal(onTab: Tab)
        case modalStackChanged([ViewController])
        
        /// Smaller number means MORE important
        var renderingImportance: Int {
            switch self {
            case .dismissedModal: return 0
            case .switched: return 1
            case .modalStackChanged: return 2
            case .presentedModal, .presentedModalInNavigationController: return 3
            case .tabStacksChanged: return 4
            }
        }
    }
    
    internal func differences(to other: ViewState) -> [ViewState.Change] {
        guard self != other else { return [] }
        
        var changes: [ViewState.Change] = []
        
        if self.selectedTab != other.selectedTab {
            changes.append(.switched(fromTab: self.selectedTab, toTab: other.selectedTab))
        }
        
        let selectedTab = other.selectedTab
        
        if self.modal != other.modal {
            // Change in the modals
            if self.modal == nil && other.modal != nil {
                // Presented a modal, where there wasn't one previously.
                switch other.modal! {
                case .single(let viewController):
                    changes.append(.presentedModal(viewController: viewController, onTab: selectedTab))
                case .stack(let viewControllers):
                    changes.append(.presentedModalInNavigationController(viewController: viewControllers.first!, onTab: selectedTab))
                }
            } else if self.modal != nil && other.modal == nil {
                // Dismissed a modal
                changes.append(.dismissedModal(onTab: selectedTab))
            } else {
                // Both non-nil, has to be a push/pop on modal navigation stack.
                let oldModal = self.modal!
                let newModal = other.modal!
                
                guard case .stack(let oldViewControllers) = oldModal, case .stack(let newViewControllers) = newModal else {
                    fatalError("Invalid state! You tried to push/pop a view controller on a presented modal without presenting that modal in a UINavigationController.")
                }
                
                if oldViewControllers.differences(to: newViewControllers).isNotEmpty {
                    changes.append(.modalStackChanged(newViewControllers))
                }
                
            }
        }
        var tabsWithNewVCs: [Tab: [ViewController]] = [:]
        for tab in Tab.allCases {
            // Compare old.tabStacks
            if self.tabStacks[tab].differences(to: other.tabStacks[tab]).isNotEmpty {
                tabsWithNewVCs[tab] = other.tabStacks[tab]
            }
        }
        
        if !tabsWithNewVCs.isEmpty {
            changes.append(.tabStacksChanged(tabsWithNewVCs.map { ($0.key, $0.value) }))
        }
        
        return changes
    }
    
}
