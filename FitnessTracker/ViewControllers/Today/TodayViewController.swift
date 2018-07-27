// 
//  TodayViewController.swift
//  FitnessTracker
//
//  Created by Swain Molster on 7/25/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import UIKit
import FitnessTrackerKit
import RxSwift
import RxCocoa

final internal class TodayViewController: UITableViewController {
    
    private let viewModel: TodayViewModelType = TodayViewModel()
    
    private let disposeBag = DisposeBag()
    
    private enum CellModel: TableCellTypesProviding {
        
        case totalCalories(Calories)
        case totalMacros(MacroCount)
        
        case meal(Meal)
        
        case addMeal
        
        static var cellTypes: [UITableViewCell.Type] {
            return []
        }
    }
    
    private lazy var dataProvider = TableDataProvider<CellModel>(
        sections: [],
        cellCreationBlock: { tableView, model, indexPath in
            switch model {
            case .totalCalories(let cals):
                let cell = TwoLabelCell()
                cell.leftText = "Calories:"
                cell.rightText = "\(cals.rawValue)"
                return cell
            case .totalMacros(let macros):
                let cell = TwoLabelCell()
                cell.leftText = "Macros:"
                cell.rightText = "P: \(macros.protein.rawValue)\nC: \(macros.carbs.rawValue)\nF: \(macros.fat.rawValue)"
                return cell
            case .meal(let meal):
                let cell = TwoLabelCell()
                cell.leftText = meal.entryDate.description
                return cell
            case .addMeal:
                let cell = DoneButtonCell()
                cell.title = "Add Meal"
                cell.doneButton.rx
                    .controlEvent(.touchUpInside)
                    .bind(onNext: self.viewModel.inputs.addEntryPressed)
                    .disposed(by: self.disposeBag)
                return cell
            }
        }
    )
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.inputs.viewWillAppear()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Today"
        self.tableView.allowsMultipleSelection = false
        
        self.tableView.set(dataProvider: self.dataProvider)
        
        self.viewModel.outputs.today
            .observeOnUI()
            .subscribe(onNext: { day in
                if let day = day {
                    self.dataProvider.sections = [
                        .init([.totalCalories(day.totalCalories), .totalMacros(day.totalMacros)]),
                        .init(day.allMeals.map(CellModel.meal)),
                        .init([.addMeal])
                    ]
                } else {
                    self.dataProvider.sections = [.init([.addMeal])]
                }
                
                self.tableView.reloadData()
            })
            .disposed(by: self.disposeBag)
        
        self.viewModel.outputs.showMealEntry
            .observeOnUI()
            .subscribe(onNext: {
                self.navigationController?.pushViewController(MealEntryViewController(), animated: true)
            })
            .disposed(by: self.disposeBag)
    }
    
}
