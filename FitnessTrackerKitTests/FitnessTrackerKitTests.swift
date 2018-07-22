//
//  FitnessTrackerKitTests.swift
//  FitnessTrackerKitTests
//
//  Created by Swain Molster on 7/20/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import XCTest
@testable import FitnessTrackerKit

class FitnessTrackerKitTests: XCTestCase {
    
    let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
    
    func testDataProviderUpdating() {
        let provider = TableDataProvider<Int>(
            for: tableView,
            models: [],
            cellCreationBlock: { (tableView, integer, indexPath) -> UITableViewCell in
                let cell = UITableViewCell()
                cell.tag = integer
                return cell
            }
        )
        
        tableView.reloadData()
        
        XCTAssert(provider.numberOfSections(in: tableView) == 1, "Should be zero sections")
        
        XCTAssert(provider.tableView(tableView, numberOfRowsInSection: 0) == 0, "Should be zero rows")
        
        provider.sections = [.init(models: [1, 2, 3])]
        
        let newlyVisibleCells = tableView.visibleCells
        XCTAssert(newlyVisibleCells.count == 3, "Should be 3 cells visible now.")
        
        XCTAssert(provider.numberOfSections(in: tableView) == 1, "Should be one section now.")
        XCTAssert(provider.tableView(tableView, numberOfRowsInSection: 0) == 3, "Should be three rows now.")
    }
}
