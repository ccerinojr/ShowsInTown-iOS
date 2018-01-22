//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import UIKit

class CollectionTitleHeaderView: UICollectionReusableView, ReusableViewRegisterable {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        self.preservesSuperviewLayoutMargins = true
        
        self.addSubview(self.label)
        self.label.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor).isActive = true
        self.label.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor).isActive = true
        self.label.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor).isActive = true
        self.label.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor).isActive = true
    }
    
    func configure(with text: String?) {
        self.label.text = text
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.label.text = nil
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22.0, weight: .bold)
        label.textColor = .sitDarkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
}
