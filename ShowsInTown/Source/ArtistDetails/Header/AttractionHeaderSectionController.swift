//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import UIKit

class AttractionHeaderSectionController: NSObject, TableViewSectionController {
    
    init(title: String, images: [DiscoveryRemoteImage], tableView: UITableView) {
        
        self.title = title
        self.images = images
        
        super.init()
        
        AttractionHeaderCell.registerCell(in: tableView)
    }
    
    //MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 64.0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AttractionHeaderCell.reuseIdentifier, for: indexPath) as! AttractionHeaderCell
        
        let url = self.images.image(forTargetWidth: tableView.bounds.width * 1.5)?.url
        cell.update(withTitle: self.title, attractionImageURL: url)
        
        return cell
    }
    
    //MARK: - Private variables
    
    fileprivate let title: String
    fileprivate let images: [DiscoveryRemoteImage]
    
}

