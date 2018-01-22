//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import UIKit

class LoadingFooterView: UIView {
    
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
    
    //MARK: - Private
    
    fileprivate let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private func setup() {
        self.backgroundColor = .clear
        
        self.addSubview(spinner)
        self.spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.spinner.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8.0).isActive = true
        
        self.spinner.startAnimating()
    }
}
