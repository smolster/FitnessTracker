//
//  TableDataProviderTests.swift
//  FitnessTrackerKitTests
//
//  Created by Swain Molster on 7/20/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import XCTest
@testable import FitnessTrackerKit

class TableDataProviderTests: XCTestCase {
    
    let tableView = UITableView()
    
    func testSettingSections() {
        let dataProvider = TableDataProvider<Int>(for: tableView, models: [], cellCreationBlock: { (tableView, integer, indexPath) -> UITableViewCell in
            return UITableViewCell()
        })
        
        XCTAssert(dataProvider.tableView(tableView, numberOfRowsInSection: 0) == 0, "Should have 0 rows at first")
        
        dataProvider.sections = [TableDataProvider<Int>.Section(models: [0, 1, 2])]
        
        XCTAssert(dataProvider.tableView(tableView, numberOfRowsInSection: 0) == 3, "Should have 3 rows now.")
        
    }
}
