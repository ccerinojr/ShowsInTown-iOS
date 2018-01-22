//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import UIKit

class TrackCollectionViewCell: UICollectionViewCell, ReusableViewRegisterable, ContentItemConfigurable {
    typealias ContentItem = Track
    
    static let cellHeight: CGFloat = 60.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stackView = UIStackView(arrangedSubviews: [self.trackArtworkImageView, self.label])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(stackView)
        
        stackView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .sitSeparatorGray
        self.contentView.addSubview(separator)
        
        separator.leadingAnchor.constraint(equalTo: self.label.leadingAnchor).isActive = true
        separator.trailingAnchor.constraint(equalTo: self.label.trailingAnchor).isActive = true
        separator.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        self.separatorHeightConstraint = separator.heightAnchor.constraint(equalToConstant: 1.0)
        self.separatorHeightConstraint?.isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.trackArtworkImageView.image = nil
        self.label.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let scale = self.window?.screen.scale ?? 1.0
        self.separatorHeightConstraint?.constant = 1.0 / scale
    }
    
    func configure(with item: Track) {
        self.label.text = item.name
        self.trackArtworkImageView.pin_setImage(from: item.artworkURL)
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.label.textColor = .sitGreen
                self.trackArtworkImageView.addSubview(self.pauseIconView)
                self.pauseIconView.translatesAutoresizingMaskIntoConstraints = false
                self.pauseIconView.topAnchor.constraint(equalTo: self.trackArtworkImageView.topAnchor).isActive = true
                self.pauseIconView.leftAnchor.constraint(equalTo: self.trackArtworkImageView.leftAnchor).isActive = true
                self.pauseIconView.bottomAnchor.constraint(equalTo: self.trackArtworkImageView.bottomAnchor).isActive = true
                self.pauseIconView.rightAnchor.constraint(equalTo: self.trackArtworkImageView.rightAnchor).isActive = true
            } else {
                self.label.textColor = .sitDarkGray
                self.pauseIconView.removeFromSuperview()
            }
        }
    }
    
    //MARK: Private variables
    
    private let label: UILabel = {
        let textLabel = UILabel()
        
        textLabel.numberOfLines = 2
        textLabel.font = UIFont.systemFont(ofSize: 17.0)
        textLabel.textColor = .sitDarkGray
        
        return textLabel
    }()
    
    private let trackArtworkImageView: UIImageView = {
        let imageView = RoundedCornerImageView()
        imageView.clipsToBounds = true
        
        imageView.widthAnchor.constraint(equalToConstant: TrackCollectionViewCell.imageSize.width).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: TrackCollectionViewCell.imageSize.height).isActive = true
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentHuggingPriority(.required, for: .vertical)
        
        return imageView
    }()
    
    private var separatorHeightConstraint: NSLayoutConstraint?
    
    private var pauseIconView: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor.sitGreen.withAlphaComponent(0.7)
        
        if let image = UIImage(named: "icPause") {
            let imageView = UIImageView(image: image)
            view.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }
        
        return view
    }()
    
    private static let imageSize = CGSize(width: 44.0, height: 44.0)

}
