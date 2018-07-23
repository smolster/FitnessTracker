// 
//  MealComponentSelectionViewController.swift
//  FitnessTracker
//
//  Created by Swain Molster on 7/22/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import UIKit
import FitnessTrackerKit
import ReactiveCocoa
import ReactiveSwift
import Result

final internal class MealComponentSelectionViewController: UITableViewController {
    
    private let viewModel: MealComponentSelectionViewModelType = MealComponentSelectionViewModel()
    
    enum CellModel: TableCellTypesProviding {
        case item(Meal.Component)
        case createNew
        
        static var cellTypes: [UITableViewCell.Type] {
            return [MealComponentSelectionCell.self]
        }
    }
    
    private let chosenBlock: (Meal.Component) -> Void
    private let kind: Meal.Component.Kind
    
    internal init(kind: Meal.Component.Kind, _ chosenBlock: @escaping (Meal.Component) -> Void) {
        self.kind = kind
        self.chosenBlock = chosenBlock
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var dataProvider = TableDataProvider<CellModel>(
        sections: [],
        cellCreationBlock: { tableView, model, indexPath in
            switch model {
            case .item(let component):
                let cell = tableView.dequeueReusableCell(withType: MealComponentSelectionCell.self, for: indexPath)
                cell.configure(with: component)
                return cell
            case .createNew:
                let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                cell.textLabel?.text = self.kind.createNewText
                return cell
            }
        },
        didSelectBlock: { [unowned self] tableView, dataProvider, model, indexPath in
            switch model {
            case .item(let component):
                self.viewModel.inputs.componentSelected(component)
                self.chosenBlock(component)
            case .createNew:
                self.viewModel.inputs.createNewPressed()
            }
        }
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(CellModel.cellTypes)
        self.tableView.allowsMultipleSelection = false
        self.tableView.set(dataProvider: self.dataProvider)
        
        self.viewModel.outputs.components
            .observe(on: UIScheduler())
            .observeValues { components in
                self.dataProvider.sections = components
                .isEmpty ?
                    [.init([.createNew])] :
                    [.init(components.map { CellModel.item($0) }), .init([.createNew])]
                self.tableView.reloadData()
            }
        
        self.viewModel.outputs.goToCreateNew
            .observe(on: UIScheduler())
            .observeValues { kind in
                self.present(kind.createNewViewController(), animated: true, completion: nil)
            }
        
        self.viewModel.outputs.dismissIfPresented
            .observe(on: UIScheduler())
            .observeValues {
                if self.isBeingPresented {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.inputs.viewWillAppear(with: self.kind)
    }
    
}

fileprivate extension Meal.Component.Kind {
    fileprivate var createNewText: String {
        switch self {
        case .ingredient:   return "Create new ingredient..."
        case .recipe:       return "Create new recipe..."
        }
    }
    
    fileprivate func createNewViewController() -> UIViewController {
        switch self {
        case .ingredient:   return UINavigationController(rootViewController: IngredientCreationViewController())
        case .recipe:       return UINavigationController(rootViewController: RecipeCreationViewController())
        }
    }
}
