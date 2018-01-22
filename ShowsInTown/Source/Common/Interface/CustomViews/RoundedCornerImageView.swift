//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import UIKit

class RoundedCornerImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    override init(image: UIImage?) {
        super.init(image: image)
        self.commonInit()
    }
    
    override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit() {
        self.backgroundColor = .lightGray
        self.layer.cornerRadius = 4.0
        self.contentMode = .scaleAspectFill
        self.layer.borderColor = UIColor.sitSeparatorGray.cgColor
    }

    override func layoutSubviews() {
        
        let scale = self.window?.screen.scale ?? 1.0
        self.layer.borderWidth = 1.0 / scale
        super.layoutSubviews()
    }
}
