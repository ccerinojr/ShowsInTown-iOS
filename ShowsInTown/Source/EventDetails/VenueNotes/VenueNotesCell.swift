//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import UIKit

class VenueNotesCell: UITableViewCell, ReusableNibViewRegisterable {

    func update(withTitle title: String, notes: String) {
        self.titleLabel.text = title
        self.notesLabel.text = notes
    }
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var notesLabel: UILabel!
}
