//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import UIKit

class RoutingTableViewController: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView? {
        didSet {
            oldValue?.dataSource = nil
            oldValue?.delegate = nil
            
            self.tableView?.dataSource = self
            self.tableView?.delegate = self
            self.tableView?.reloadData()
        }
    }
    
    var sections: [TableViewSectionController] = [] {
        didSet {
            self.tableView?.reloadData()
        }
    }
    
    func syncSelection(animated: Bool) {
        guard let tableView = self.tableView else { return }
        
        for sectionIndex in 0..<self.sections.count {
            let selectedIndexes = self.sections[sectionIndex].selectedIndexes
            selectedIndexes.forEach {
                tableView.selectRow(at: IndexPath(row: $0, section: sectionIndex), animated: animated, scrollPosition: .none)
            }
        }
    }
}

// MARK: - TableView

extension RoutingTableViewController {
    
    //MARK: Counts
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].tableView(tableView, numberOfRowsInSection: section)
    }
    
    //MARK: Cell
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.sections[indexPath.section].tableView?(tableView, estimatedHeightForRowAt: indexPath) ?? UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.sections[indexPath.section].tableView?(tableView, heightForRowAt: indexPath) ?? tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.sections[indexPath.section].tableView(tableView, cellForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.sections[indexPath.section].tableView?(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    
    //MARK: Header
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        
        return self.sections[section].tableView?(tableView, estimatedHeightForHeaderInSection: section) ?? 2.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.sections[section].tableView?(tableView, heightForHeaderInSection: section) ?? tableView.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.sections[section].tableView?(tableView, viewForHeaderInSection: section)
    }
    
    //MARK: Footer
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        let estimate = self.sections[section].tableView?(tableView, estimatedHeightForFooterInSection: section) ?? 2.0
        return estimate
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let height = self.sections[section].tableView?(tableView, heightForFooterInSection: section) ?? tableView.sectionFooterHeight
        return height
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return self.sections[section].tableView?(tableView, viewForFooterInSection: section)
    }
    
    //MARK: Selection
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if self.sections[indexPath.section].tableView(_:willSelectRowAt:) != nil {
            return self.sections[indexPath.section].tableView?(tableView, willSelectRowAt: indexPath)
        }
        
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sections[indexPath.section].tableView?(tableView, didSelectRowAt: indexPath)
    }
    
    
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        return self.sections[indexPath.section].tableView?(tableView, willDeselectRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.sections[indexPath.section].tableView?(tableView, didDeselectRowAt: indexPath)
        
    }
}
