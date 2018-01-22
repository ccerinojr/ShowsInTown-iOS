//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import UIKit

class VenueInfoCell: UITableViewCell, ReusableNibViewRegisterable {

    var isActionable: Bool = false {
        didSet {
            self.valueLabel.textColor = self.isActionable ? .sitGreen : .sitLightGray
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.isActionable = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let scale = self.window?.screen.scale ?? 1.0
        self.separatorViewHeightConstraint.constant = 1.0 / scale
    }

    func update(withTitle title: String, value: String) {
        self.titleLabel.text = title
        self.valueLabel.text = value
    }
    
    @IBOutlet private weak var separatorViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
}
