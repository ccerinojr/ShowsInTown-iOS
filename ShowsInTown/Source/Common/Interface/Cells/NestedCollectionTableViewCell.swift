//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import UIKit

class NestedCollectionTableViewCell: UITableViewCell, ReusableViewRegisterable {

    private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout)
        collectionView.clipsToBounds = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }() {
        didSet {
            self.collectionViewLayout.scrollDirection = .horizontal
            self.collectionView.collectionViewLayout = self.collectionViewLayout
        }
    }

    var collectionViewController: CollectionViewController? {
        didSet {
            oldValue?.unlinkCollectionView()
            self.collectionViewController?.linkCollectionView(self.collectionView)
        }
    }
    
    var showsSeparator: Bool = true {
        didSet {
            if showsSeparator {
                self.separator.isHidden = false
            } else {
                self.separator.isHidden = true
            }
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let scale = self.window?.screen.scale ?? 1.0
        self.separatorHeightConstraint?.constant = 1.0 / scale
    }

    private func commonInit() {
        
        self.contentView.addSubview(self.collectionView)
        self.contentView.clipsToBounds = false
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.collectionView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        self.collectionView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        self.collectionView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.collectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
        self.separator.translatesAutoresizingMaskIntoConstraints = false
        self.separator.backgroundColor = .sitSeparatorGray
        self.contentView.addSubview(self.separator)
        
        self.separator.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        self.separator.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        self.separator.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
        self.separatorHeightConstraint = self.separator.heightAnchor.constraint(equalToConstant: 1.0)
        self.separatorHeightConstraint?.isActive = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.collectionViewController = nil
        self.separator.isHidden = false
    }
    
    private let separator = UIView()
    private var separatorHeightConstraint: NSLayoutConstraint?
}
