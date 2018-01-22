//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import UIKit

fileprivate struct VenueInfo {
    let title: String
    let value: String
    let actionURL: URL?
    
    var isActionable: Bool {
        return self.actionURL != nil
    }
}

class VenueInfoSectionController: NSObject, TableViewSectionController {
    
    init(venue: DiscoveryVenue, tableView: UITableView) {

        var venueInfo = [VenueInfo]()
        
        venueInfo.append(venue.makeLocationVenueInfo())
        
        if let info = venue.makeWebsiteVenueInfo() {
            venueInfo.append(info)
        }

        if let info = venue.makeTwitterVenueInfo() {
            venueInfo.append(info)
        }
        
        self.sectionTitle = venue.name
        self.venueInfo = venueInfo
        
        VenueInfoCell.registerCell(in: tableView)
        TableSectionHeaderView.register(in: tableView)
    }
    
    //MARK: Private Variables
    fileprivate let venueInfo: [VenueInfo]
    fileprivate let sectionTitle: String
}

//MARK - TableView

extension VenueInfoSectionController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.venueInfo.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
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
        let cell = tableView.dequeueReusableCell(withIdentifier: VenueInfoCell.reuseIdentifier, for: indexPath) as! VenueInfoCell
        
        let info = self.venueInfo[indexPath.row]
        cell.update(withTitle: info.title, value: info.value)
        cell.isActionable = info.isActionable
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableSectionHeaderView.reuseIdentifier) as! TableSectionHeaderView
        
        header.configure(with: self.sectionTitle)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return self.venueInfo[indexPath.row].isActionable ? indexPath : nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let venueInfo = self.venueInfo[indexPath.row]
        guard let url = venueInfo.actionURL else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

private extension DiscoveryVenue {
    
    func makeLocationVenueInfo() -> VenueInfo {
        let mapURL: URL?
        if let url = URL(location: self.location, query: self.name), UIApplication.shared.canOpenURL(url)  {
            mapURL = url
        } else {
            mapURL = nil
        }
        
        return VenueInfo(title: NSLocalizedString("Location", comment: "Location"), value: self.address.street, actionURL: mapURL)
    }
    
    func makeTwitterVenueInfo() -> VenueInfo? {
        guard let twitterHandle = self.twitterHandle, let twitterURL = URL(string: "https://twitter.com/\(twitterHandle.replacingOccurrences(of: "@", with: ""))") else { return nil }
        return VenueInfo(title: NSLocalizedString("Twitter", comment: "Twitter"), value: twitterHandle, actionURL: twitterURL)
    }
    
    func makeWebsiteVenueInfo() -> VenueInfo? {
        guard let website = self.website else { return nil }
        return VenueInfo(title: NSLocalizedString("Website", comment: "Website"), value: NSLocalizedString("View", comment: "View"), actionURL: website)
    }
}
