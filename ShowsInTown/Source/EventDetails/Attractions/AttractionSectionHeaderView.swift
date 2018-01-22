//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import UIKit

class AttractionSectionHeaderView: UITableViewHeaderFooterView, ReusableViewRegisterable {
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        self.preservesSuperviewLayoutMargins = true
        self.contentView.preservesSuperviewLayoutMargins = true
        
        let container = UIStackView(arrangedSubviews: [self.titleLabel, self.subtitleLabel])
        container.spacing = 4
        container.axis = .vertical
        container.distribution = .fill
        container.alignment =  .fill
        container.translatesAutoresizingMaskIntoConstraints = false

        self.contentView.addSubview(container)
        
        container.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leftAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.rightAnchor).isActive = true
    }
    
    override func layoutMarginsDidChange() {
        super.layoutMarginsDidChange()
        self.labelTopConstraint?.constant = self.contentView.layoutMargins.top + self.contentView.layoutMargins.top * 0.5
    }
    
    func configure(withTitle title: String, subtitle: String) {
        self.titleLabel.text = title
        self.subtitleLabel.text = subtitle
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = nil
        self.subtitleLabel.text = nil
    }
    
    private var labelTopConstraint: NSLayoutConstraint? = nil
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22.0, weight: .bold)
        label.textColor = .sitDarkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.textColor = .sitLightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
}
