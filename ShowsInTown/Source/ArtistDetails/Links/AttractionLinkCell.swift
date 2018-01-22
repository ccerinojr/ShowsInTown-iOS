//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import UIKit

class AttractionLinkCell: UITableViewCell, ReusableNibViewRegisterable {
    
    var showsSeparator: Bool = true {
        didSet {
            if showsSeparator {
                self.separator.isHidden = false
            } else {
                self.separator.isHidden = true
            }
        }
    }
    
    var linkTitle: String? {
        didSet {
            self.linkLabel?.text = self.linkTitle
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.contentView.addSubview(self.separator)
        
        self.separator.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        self.separator.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        self.separator.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
        self.separatorHeightConstraint = self.separator.heightAnchor.constraint(equalToConstant: 1.0)
        self.separatorHeightConstraint?.isActive = true
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let scale = self.window?.screen.scale ?? 1.0
        self.separatorHeightConstraint?.constant = 1.0 / scale
    }
    
    @IBOutlet private weak var linkLabel: UILabel!
    
    private let separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .sitSeparatorGray
        return view
    }()

    private var separatorHeightConstraint: NSLayoutConstraint?
}
