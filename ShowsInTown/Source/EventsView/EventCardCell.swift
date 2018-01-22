//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import UIKit
import PINRemoteImage

class EventCardCell: UICollectionViewCell, ReusableNibViewRegisterable {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = .clear
        self.contentView.layer.cornerRadius = 14.0
        self.contentView.clipsToBounds = true

        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 16.0)
        self.layer.shadowOpacity = 0.20
        self.layer.shadowRadius = 14.0
        self.layer.shadowColor = UIColor.black.cgColor
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.eventImageView.pin_cancelImageDownload()
        self.eventImageView.image = nil
        self.mainAttractionLabel.text = nil
        self.dateLabel.text = nil
        self.openingAttractionsLabel.text = nil
    }
    
    func configure(with item: DiscoveryEvent) {
        
        let viewModel = EventViewModel(event: item)
        let image = viewModel.images.image(forTargetWidth: self.eventImageView.bounds.width * 1.5)
        
        self.mainAttractionLabel.text = viewModel.mainAttraction
        self.openingAttractionsLabel.text = viewModel.openingAttractions
        self.dateLabel.text = viewModel.dateText
        self.venueLabel.text = viewModel.venueName
        self.eventImageView.pin_setImage(from: image?.url) { (result) in
            self.backgroundImageView.image = result.image
        }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        setNeedsLayout()
        layoutIfNeeded()
        
        let targetSize = CGSize(width: layoutAttributes.size.width, height: UILayoutFittingCompressedSize.height)
        let size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .defaultHigh, verticalFittingPriority: .fittingSizeLevel)
        
        var newFrame = layoutAttributes.frame
        newFrame.size.height = ceil(size.height)
        layoutAttributes.frame = newFrame
        
        self.layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: newFrame.width, height: newFrame.height), cornerRadius: self.contentView.layer.cornerRadius).cgPath
        

        return layoutAttributes
    }

    @IBOutlet fileprivate weak var backgroundImageView: UIImageView!
    @IBOutlet fileprivate weak var eventImageView: UIImageView!
    @IBOutlet fileprivate weak var dateLabel: UILabel!
    @IBOutlet fileprivate weak var mainAttractionLabel: UILabel!
    @IBOutlet fileprivate weak var openingAttractionsLabel: UILabel!
    @IBOutlet fileprivate weak var venueLabel: UILabel!
}
