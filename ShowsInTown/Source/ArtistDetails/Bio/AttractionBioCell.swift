//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import UIKit

class AttractionBioCell: UITableViewCell, ReusableNibViewRegisterable {
    
    func update(with bio: String) {
        self.bioLabel.text = bio
    }
    
    @IBOutlet private weak var bioLabel: UILabel!
}

