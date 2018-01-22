//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import UIKit

class AttractionHeaderCell: UITableViewCell, ReusableNibViewRegisterable {
    
    func update(withTitle title: String, attractionImageURL: URL?) {
        self.titleLabel.text = title
        self.cellImageView.pin_setImage(from: attractionImageURL)
    }
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var cellImageView: UIImageView!
}

