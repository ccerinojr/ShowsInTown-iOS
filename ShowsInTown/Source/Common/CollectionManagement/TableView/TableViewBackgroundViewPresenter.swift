//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import Foundation
import UIKit

protocol TableViewBackgroundViewPresenter {
    var tableView: UITableView! { get }
}

extension TableViewBackgroundViewPresenter {
    func showBackgroundView(_ view: TableViewBackgroundView) {
        self.tableView.backgroundView = view
    }
    
    func removeBackgroundView() {
        self.tableView.backgroundView = nil
    }
}
