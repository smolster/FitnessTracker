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
            self.viewModel.inputs.selectedDay(day)
        }
    )
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.inputs.viewWillAppear()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "All Meals"
        self.tableView.set(dataProvider: dataProvider)
        
        self.viewModel.outputs.days
            .observeOnUI()
            .subscribe(onNext: { days in
                self.dataProvider.sections = [.init(days)]
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        self.viewModel.outputs.showAlert
            .observeOnUI()
            .subscribe(onNext: { (title, message) in
                self.showAlert(
                    title: title,
                    message: message,
                    buttons: [
                        .ok { [unowned self] _ in
                            self.tableView.deselectSelectedRows(animated: false)
                            self.presentedViewController?.dismiss(animated: true, completion: nil)
                        }
                    ]
                )
            })
            .disposed(by: self.disposeBag)
    }

}
