//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import UIKit

class VenueNotesSectionController: NSObject, TableViewSectionController {
    
    init(title: String, notes: [Note], tableView: UITableView) {
        self.title = title
        self.notes = notes
        VenueNotesCell.registerCell(in: tableView)
        TableSectionHeaderView.register(in: tableView)
    }

    struct Note {
        let title: String
        let notes: String
    }
    
    //MARK: Private Variables
    fileprivate let notes: [Note]
    fileprivate let title: String
}

//MARK: - TableView
extension VenueNotesSectionController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notes.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VenueNotesCell.reuseIdentifier, for: indexPath) as! VenueNotesCell
        
        let notes = self.notes[indexPath.row]
        cell.update(withTitle: notes.title, notes: notes.notes)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableSectionHeaderView.reuseIdentifier) as! TableSectionHeaderView
        
        header.configure(with: title)
        
        return header
    }
}
