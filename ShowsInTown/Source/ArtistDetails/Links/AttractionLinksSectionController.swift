//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import UIKit

class AttractionLinksSectionController: NSObject, TableViewSectionController {

    var didSelectURL: ((_ url: URL) -> ())?
    
    init(links: [DiscoveryAttraction.ExternalSource: [URL]], tableView: UITableView) {
        let supportedLinks = links.filter { (content) -> Bool in
            return AttractionLinksSectionController.supportedSources.contains(content.key)
        }

        self.linksBySources = supportedLinks
        self.sources = Array(supportedLinks.keys)
        
        AttractionLinkCell.registerCell(in: tableView)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AttractionLinkCell.reuseIdentifier, for: indexPath) as! AttractionLinkCell
        let source = self.sources[indexPath.row]
        let indexOfLastSource = self.sources.count - 1
        
        cell.linkTitle = String(describing: source)
        cell.showsSeparator = indexOfLastSource != indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let source = self.sources[indexPath.row]
        let hasLinks = self.linksBySources[source]?.isEmpty == false 
        return hasLinks ? indexPath : nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let source = self.sources[indexPath.row]
        guard let url = self.linksBySources[source]?.first else { return }
        self.didSelectURL?(url)
    }

    //MARK: Private
    
    private static let supportedSources: [DiscoveryAttraction.ExternalSource] = [.homepage, .itunes, .spotify, .youtube, .instagram, .twitter, .facebook, .wiki]
    private let linksBySources:  [DiscoveryAttraction.ExternalSource: [URL]]
    private let sources: [DiscoveryAttraction.ExternalSource]
}
