//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import UIKit

class TableViewBackgroundView: UIView {

    let contentView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        self.addSubview(self.contentView)
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor).isActive = true
        self.contentView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor).isActive = true
        self.contentView.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor).isActive = true
        self.contentView.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor).isActive = true
    }
}
