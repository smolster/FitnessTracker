//
//  TodayViewController.swift
//  FitnessTracker
//
//  Created by Swain Molster on 7/22/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import UIKit

final internal class TodayViewController: UIViewController {
    
    let viewModel: TodayViewModelType = TodayViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Today"
    }
}
