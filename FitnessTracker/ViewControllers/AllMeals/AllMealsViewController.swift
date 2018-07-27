//
//  AllMealsViewController.swift
//  FitnessTracker
//
//  Created by Swain Molster on 7/18/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result
import FitnessTrackerKit
import RxSwift

internal final class AllMealsViewController: UITableViewController {
    
    let disposeBag = DisposeBag()
    private let viewModel: AllMealsViewModelType = AllMealsViewModel()
    
    private lazy var dataProvider = TableDataProvider<Day>(
        models: [],
        cellCreationBlock: { tableView, day, indexPath in
            let cell = UITableViewCell(style: .default, reuseIdentifier: "CELL")
            cell.textLabel?.text = day.displayDate.dateString
            cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline, compatibleWith: self.traitCollection)
            cell.accessoryType = .disclosureIndicator
            return cell
        },
        didSelectBlock: { [unowned self] tableView, _, day, indexPath in
            let msg = "Total Calories: \(day.totalCalories), Total Macros: \(day.totalMacros)"
            let alert = UIAlertController(title: day.date.description, message: msg, preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
        }
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "All Meals"
        self.tableView.set(dataProvider: dataProvider)
        self.viewModel.outputs.days
            .observeOnUI()
            .subscribe(onNext: { days in
                self.dataProvider.sections = [.init(days)]
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.inputs.viewWillAppear()
    }

}
