//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import UIKit

class LoadingView: TableViewBackgroundView {

    var text: String? {
        didSet {
            self.label.text = text
            self.label.isHidden = text == nil
        }
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func startAnimating() {
        self.spinner.startAnimating()
    }
    
    func stopAnimating() {
        self.spinner.stopAnimating()
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        self.stopAnimating()
    }
    
    //MARK: - Private
    
    fileprivate let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    fileprivate let label = UILabel()

    private func setup() {
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        self.label.textColor = .sitLightGray
        self.label.numberOfLines = 0
        self.label.textAlignment = .center
        self.label.isHidden = true
        self.spinner.color = .sitDarkGray
        
        let container = UIStackView(arrangedSubviews: [spinner, label])
        container.axis = .vertical
        container.alignment = .center
        container.translatesAutoresizingMaskIntoConstraints = false
        container.spacing = 8
        
        self.contentView.addSubview(container)
        container.centerYAnchor.constraint(equalTo: self.layoutMarginsGuide.centerYAnchor).isActive = true
        container.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20.0).isActive = true
        container.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20.0).isActive = true
    }
}
