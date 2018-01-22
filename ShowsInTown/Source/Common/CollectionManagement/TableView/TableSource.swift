//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import Foundation

import Foundation
import UIKit

class TableSource<Item, ItemCell: UITableViewCell>: NSObject, UITableViewDataSource, UITableViewDelegate where ItemCell: ReusableViewRegisterable {
    
    enum CellSizing {
        case fixed(height: CGFloat)
        case dynamic(estimatedHeight: CGFloat)
    }
    
    var selectedItems: [Item] {
        guard let selectedIndexPaths = self.tableView?.indexPathsForSelectedRows else { return [] }
        
        var selected = [Item]()
        selectedIndexPaths.forEach {
            selected.append(self.items[$0.row])
        }
        
        return selected
    }
    
    var numberOfSelectedItems: Int {
        return self.tableView?.indexPathsForSelectedRows?.count ?? 0
    }
    
    var numberOfItems: Int {
        return self.items.count
    }
    
    var canSelectItem: ((_ item: Item) -> Bool)?
    
    var selectionDidChange: (() -> ())?
    
    var didSelectItem: ((_ item: Item) -> ())?
    
    var configureItemCellHandler: ((_ cell: ItemCell, _ item: Item) -> ())?
    
    var tableView: UITableView? {
        didSet {
            guard let tableView = self.tableView else { return }
            tableView.reloadData()
        }
    }

    let cellSizing: CellSizing
    
    init(tableView: UITableView?, cellSizing: CellSizing, didScrollHandler: @escaping () -> ()) {
        self.tableView = tableView
        self.didScrollHandler = didScrollHandler
        self.cellSizing = cellSizing
        
        super.init()
    }
    
    func insert(_ items: [Item]) {
        guard items.isEmpty == false else { return }
        
        if self.items.isEmpty {
            self.items += items
            self.tableView?.reloadData()
        } else {
            let indexOfLastInventory = self.items.count-1
            self.items += items
            
            var indexPaths = [IndexPath]()
            for i in 1...items.count {
                let indexPath = IndexPath(row: indexOfLastInventory+i, section: 0)
                indexPaths.append(indexPath)
            }
            
            guard indexPaths.isEmpty == false else { return }
            
            self.tableView?.insertRows(at: indexPaths, with: .automatic)
        }
    }
    
    func item(at indexPath: IndexPath) -> Item {
        return self.items[indexPath.row]
    }
    
    func update(_ updates: [IndexPath: Item]) {
        
        updates.forEach { (indexPath, inventory) in
            self.items[indexPath.row] = inventory
        }
        
        self.tableView?.reloadRows(at: Array(updates.keys), with: .none)
    }
    
    func clear() {
        self.items = []
        self.tableView?.reloadData()
    }
    
    func selectAll() {
        guard let tableView = self.tableView else { return }
        
        tableView.beginUpdates()
        
        for row in 0..<self.items.count {
            tableView.selectRow(at: IndexPath(row: row, section: 0), animated: true, scrollPosition: .none)
        }
        
        tableView.endUpdates()
    }
    
    func unselectAll() {
        guard let tableView = self.tableView else { return }

        tableView.beginUpdates()
        
        for row in 0..<self.items.count {
            tableView.deselectRow(at: IndexPath(row: row, section: 0), animated: true)
        }
        
        tableView.endUpdates()
    }
    

    
    //MARK: TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.reuseIdentifier, for: indexPath)
        let item = self.item(at: indexPath)
        
        guard let itemCell = cell as? ItemCell else { return  cell }
        
        self.configureItemCellHandler?(itemCell, item)
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.didScrollHandler()
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let item = self.item(at: indexPath)
        let canSelect = self.canSelectItem?(item) ?? true
        return canSelect ? indexPath : nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectionDidChange?()

        let item = self.item(at: indexPath)
        self.didSelectItem?(item)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.selectionDidChange?()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.cellSizing {
        case .fixed(let height):
            return height
        case .dynamic:
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.cellSizing {
        case .fixed(let height):
            return height
        case .dynamic(let estimatedHeight):
            return estimatedHeight
        }
    }
    
    //MARK: Private Variables
    
    fileprivate var items = [Item]()
    fileprivate let didScrollHandler: () -> ()
    
}

