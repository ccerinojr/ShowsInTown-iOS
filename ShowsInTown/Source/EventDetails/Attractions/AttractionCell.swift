//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import UIKit
import PINRemoteImage

class AttractionCell: UICollectionViewCell, ReusableNibViewRegisterable, ContentItemConfigurable {
    typealias ContentItem = Attraction
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 4.0
        self.contentView.clipsToBounds = true
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowOpacity = 1.0
    }
    
    override func layoutSubviews() {
        self.layer.shadowPath = self.showsShadow ? UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath : nil
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel.text = nil
        self.imageView.pin_cancelImageDownload()
        self.imageView.image = nil
        self.bioLabel.text = nil
    }
    
    func configure(with item: Attraction) {
        self.nameLabel.text = item.name
        self.bioLabel.text = item.bio
        self.imageView.pin_setImage(from: item.images.image(forTargetWidth: self.imageView.bounds.width*1.5)?.url)
        
        if item.canShowADP {
            self.contentView.backgroundColor = .white
            self.contentView.layoutMargins = UIEdgeInsetsMake(16.0, 16.0, 16.0, 16.0)
            self.showsShadow = true
        } else {
            self.contentView.backgroundColor = .clear
            self.contentView.layoutMargins = .zero
            self.showsShadow = false
        }
    }
    
    //MARK: Private
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var bioLabel: UILabel!
    private var showsShadow = false {
        didSet {
            self.layer.shadowColor = self.showsShadow ? UIColor.black.withAlphaComponent(0.10).cgColor : nil
            self.layer.shadowOpacity = self.showsShadow ? 1.0 : 0.0
        }
    }

}
