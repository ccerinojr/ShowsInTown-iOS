//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import UIKit

class AttractionBioSectionController: NSObject, TableViewSectionController {
    
    init(bio: String, tableView: UITableView) {
        
        self.bio = bio
        
        super.init()
        
        AttractionBioCell.registerCell(in: tableView)
    }
    
    //MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AttractionBioCell.reuseIdentifier, for: indexPath) as! AttractionBioCell
        
        cell.update(with: self.bio)
        
        return cell
    }
    
    //MARK: - Private variables
    
    fileprivate let bio: String
}

