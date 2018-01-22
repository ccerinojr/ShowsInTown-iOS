//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import UIKit
import PromiseKit

class AttractionsSectionController: NSObject, TableViewSectionController {
    
    typealias SectionHeader = (title: String, subtitle: String)

    var attractionSelectedHandler: ((_ attraction: Attraction) -> ())? {
        didSet {
            self.carouselDataSource.didSelectItem = { [weak self] (item, _) in
                self?.attractionSelectedHandler?(item)
            }
        }
    }
    
    init(attractions: [Attraction], sectionHeader: SectionHeader, tableView: UITableView) {
        self.carouselDataSource = CollectionSource<AttractionCell>(contentItems: attractions)
        self.sectionHeader = sectionHeader
        
        super.init()
        
        NestedCollectionTableViewCell.registerCell(in: tableView)
        AttractionSectionHeaderView.register(in: tableView)
        
        self.carouselDataSource.shouldSelectItem = { (item) -> Bool in
            return item.canShowADP
        }
        
        let _ = when(fulfilled: self.loadBios()).then { [weak self] (updates) -> () in
            self?.carouselDataSource.contentItems = updates
        }
    }
    

    //MARK: Private Variables
    
    fileprivate let carouselDataSource: CollectionSource<AttractionCell>
    fileprivate let carouselLayout = CarouselCollectionViewLayout()
    fileprivate let sectionHeader: SectionHeader
    fileprivate let bioService = WikipediaBioService(session: URLSession.shared)
    
    private func loadBios() -> [Promise<(Attraction)>] {
        
        let bioLoads = self.carouselDataSource.contentItems.flatMap { (attraction) -> Promise<(Attraction)>? in
            return self.bioService.bio(for: attraction).then{ (bio) -> (Attraction) in
                var attraction = attraction
                attraction.bio = bio
                return attraction
            }.recover(execute: { (_) -> (Attraction) in
                return attraction
            })
        }
        
        return bioLoads
    }
}

//MARK: - TableView

extension AttractionsSectionController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NestedCollectionTableViewCell.reuseIdentifier, for: indexPath)
        guard let carousel = cell as? NestedCollectionTableViewCell else { return cell }
        
        AttractionCell.registerCell(in: carousel.collectionView)
        
        carousel.collectionViewLayout = self.carouselLayout
        carousel.collectionView.showsHorizontalScrollIndicator = false
        carousel.collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        carousel.showsSeparator = false
        carousel.collectionViewController = self.carouselDataSource
        
        let gradient = GradientView()
        gradient.startingAndEndingColors = (starting: UIColor.white, ending: UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0))
        gradient.startingAndEndingLocations = (starting: 0.25, ending: 0.8)
        carousel.collectionView.backgroundView = gradient
        
        return carousel
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ceil(tableView.bounds.height * 0.55)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 64.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: AttractionSectionHeaderView.reuseIdentifier) as? AttractionSectionHeaderView else { return nil }
        view.configure(withTitle: self.sectionHeader.title, subtitle: self.sectionHeader.subtitle)
        return view
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let carousel = cell as! NestedCollectionTableViewCell
        
        var sectionInsets = tableView.layoutMargins
        sectionInsets.top = 10.0
        sectionInsets.bottom = 10.0
        
        carousel.collectionViewLayout.sectionInset = sectionInsets
    }
}
