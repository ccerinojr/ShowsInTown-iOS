//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import UIKit
import PromiseKit
import SafariServices

class AttractionDetailsViewController: UITableViewController {
    var attraction: Attraction!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = .white
        self.tableView.separatorStyle = .none
        self.tableView.sectionHeaderHeight = CGFloat.leastNormalMagnitude
        
        self.routingTableController = RoutingTableViewController()
        self.routingTableController.tableView = self.tableView
        self.routingTableController.sections = self.makeSections(attraction: self.attraction)
        
        self.loadExternalData()
    }
    
    //MARK: - Private Variables
    
    fileprivate let trackProvider: TrackProvider = ITunesTrackProvider(session: URLSession.shared)
    fileprivate let bioService = WikipediaBioService(session: URLSession.shared)
    fileprivate var routingTableController: RoutingTableViewController!
    
    private func loadExternalData() {
        
        let fetchTracks = self.trackProvider.tracks(for: attraction, limit: 9).recover { (_) -> [Track] in
            return []
        }
        
        let fetchBio = self.bioService.bio(for: attraction).recover { (_) -> String in
            return ""
        }
        
        let _ = when(fulfilled: fetchTracks, fetchBio).then { [weak self] (results) -> Void in
            guard let strongSelf = self else { return }
            strongSelf.attraction.bio = results.1
            strongSelf.attraction.tracks = results.0
            strongSelf.routingTableController.sections = strongSelf.makeSections(attraction: strongSelf.attraction)
        }
    }
    
    private func makeSections(attraction: Attraction) -> [TableViewSectionController] {
        
        var sections = [TableViewSectionController]()
        
        let headerSection = AttractionHeaderSectionController(title: attraction.name, images: attraction.images, tableView: self.tableView)
        sections.append(headerSection)
        
        if attraction.tracks.isEmpty == false {
            let tracksSectionDelegate = TracksSectionController(tracks: attraction.tracks, tableView: self.tableView)
            sections.append(tracksSectionDelegate)
        }
        
        if let bio = attraction.bio, bio.isEmpty == false {
            let bioSection = AttractionBioSectionController(bio: bio, tableView: self.tableView)
            sections.append(bioSection)
        }
        
        if attraction.externalLinks.isEmpty == false {
            let linksSection = AttractionLinksSectionController(links: self.attraction.externalLinks, tableView: self.tableView)
            sections.append(linksSection)
            
            linksSection.didSelectURL = { [unowned self] (url) in
                let webView = SFSafariViewController(url: url)
                webView.preferredControlTintColor = .sitGreen
                self.present(webView, animated: true, completion: nil)
            }
        }
        
        return sections
    }
}
