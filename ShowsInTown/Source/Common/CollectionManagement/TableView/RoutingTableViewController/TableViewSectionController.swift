//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//
import Foundation
import UIKit

protocol TableViewSectionController: UITableViewDataSource, UITableViewDelegate {
    var selectedIndexes: [Int] { get }
}

extension TableViewSectionController {
    var selectedIndexes: [Int] { return [] }
}
