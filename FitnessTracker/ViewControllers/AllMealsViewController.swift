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

internal final class AllMealsViewController: UITableViewController {
    
    private let token = Lifetime.Token()
    private var lifetime: Lifetime { return .init(self.token) }
    
    private let viewModel: AllMealsViewModelType = AllMealsViewModel()
    
    let dataProvider = TableDataProvider<Day>(
        for: UITableView(),
        models: [],
        cellCreationBlock: { tableView, day, indexPath in
            let cell = tableView.dequeueReusableCell(withType: UITableViewCell.self, for: indexPath)
            cell.textLabel?.text = "\(day.date)"
            return cell
        }
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register([UITableViewCell.self])
        self.tableView.dataSource = dataProvider
        self.viewModel.outputs.days
            .observe(on: UIScheduler())
            .observeValues { days in
                self.dataProvider.sections = [.init(models: days)]
            }
    }
}
