// 
//  ChooseRecipeViewController.swift
//  FitnessTracker
//
//  Created by Swain Molster on 7/22/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result
import FitnessTrackerKit

final internal class ChooseRecipeViewController: UITableViewController {
    
    private let viewModel: ChooseRecipeViewModelType = ChooseRecipeViewModel()
    
    internal init() {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum CellModel {
        case existingRecipe
        case createNew
        case done
    }
    
    private lazy var dataProvider = TableDataProvider<CellModel>(
        sections: [.init([.createNew]), .init([.done])],
        cellCreationBlock: { tableView, model, indexPath in
            
        },
        didSelectBlock: { [unowned self] tableView, dataProvider, model, indexPath in
            switch model {
            case .createNew:
                return
            default: return
            }
        }
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}
