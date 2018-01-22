//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

protocol ContentItemConfigurable {
    associatedtype ContentItem
    func configure(with item: ContentItem)
}
