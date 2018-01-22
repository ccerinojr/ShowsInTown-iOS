//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import UIKit
import AVFoundation

class TracksSectionController: NSObject, TableViewSectionController {
    
    
    init(tracks: [Track], tableView: UITableView) {
        self.carouselDataSource = CollectionSource<TrackCollectionViewCell>(contentItems: tracks)
        
        super.init()
        
        self.carouselDataSource.didSelectItem = { [weak self] (track, indexPath) in
            self?.play(track: track)
        }
        
        self.carouselDataSource.didDeselectItem = { [weak self] (track, indexPath) in
            guard let currentPlayingTrack = self?.currentlyPlayingTrack, track.previewURL == currentPlayingTrack.previewURL else { return }
            self?.stopPlayingCurrentTrack()
        }
        
        NestedCollectionTableViewCell.registerCell(in: tableView)
    }
    
    deinit {
        self.removePlayToEndTimeObserver()
    }
    
    //MARK: - Private Variables
    
    fileprivate let carouselDataSource: CollectionSource<TrackCollectionViewCell>
    fileprivate var player: AVPlayer?
    fileprivate var playToEndObserver: Any?
    fileprivate var currentlyPlayingTrack: Track?
    
    fileprivate let carouselLayout: CarouselCollectionViewLayout = {
        let layout = CarouselCollectionViewLayout()
        layout.page = CarouselCollectionViewLayout.Page(rows: 3, columns: 1)
        return layout
    }()
}

//MARK: - TableView

extension TracksSectionController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NestedCollectionTableViewCell.reuseIdentifier, for: indexPath)
        guard let carousel = cell as? NestedCollectionTableViewCell else { return cell }
        
        TrackCollectionViewCell.registerCell(in: carousel.collectionView)
        
        carousel.collectionView.backgroundColor = UIColor.white
        carousel.collectionViewLayout = self.carouselLayout
        carousel.collectionView.showsHorizontalScrollIndicator = false
        carousel.collectionView.allowsMultipleSelection = true
        carousel.showsSeparator = false
        carousel.collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        carousel.collectionViewController = self.carouselDataSource
        
        return carousel
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let carousel = cell as? NestedCollectionTableViewCell else { return }
        carousel.collectionViewLayout.sectionInset = UIEdgeInsetsMake(10.0, tableView.layoutMargins.left, 10.0, tableView.layoutMargins.right)
    }
}

//MARK: - Private Helpers

private extension TracksSectionController {
    
    func play(track: Track) {
        self.stopPlayingCurrentTrack()
        
        let player = AVPlayer(url: track.previewURL)
        self.addPlayToEndTimeObserver(with: { [weak self] in
            self?.stopPlayingCurrentTrack()
        })
        
        self.player = player
        self.currentlyPlayingTrack = track
        player.play()

    }
    
    func stopPlayingCurrentTrack() {
        self.player?.pause()
        self.removePlayToEndTimeObserver()
        self.player = nil
        
        if let currentlyPlayingTrack = self.currentlyPlayingTrack {
            let currentlyPlayingIndexPath = self.carouselDataSource.collectionView?.indexPathsForSelectedItems?.first(where: { (indexPath) -> Bool in
                let track = self.carouselDataSource.contentItems[indexPath.item]
                return track.previewURL == currentlyPlayingTrack.previewURL
            })
            
            if let currentlyPlayingIndexPath = currentlyPlayingIndexPath {
                self.carouselDataSource.collectionView?.deselectItem(at: currentlyPlayingIndexPath, animated: true)
            }
            
            self.currentlyPlayingTrack = nil
        }
        
    }
    
    func removePlayToEndTimeObserver() {
        if let observer = self.playToEndObserver {
            self.player?.removeTimeObserver(observer)
            self.playToEndObserver = nil
        }
    }
    
    func addPlayToEndTimeObserver(with updateHandler: @escaping () -> Void) {
        guard let player = self.player, let playerItem = player.currentItem else { return }
        let assetDuration = CMTimeMultiplyByFloat64(playerItem.asset.duration, 1.0)
        self.playToEndObserver = player.addBoundaryTimeObserver(forTimes: [NSValue(time:assetDuration)], queue: DispatchQueue.main, using: updateHandler)
    }
}

