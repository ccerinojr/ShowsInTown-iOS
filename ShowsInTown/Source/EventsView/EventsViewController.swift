//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import UIKit
import CoreLocation
import PromiseKit

class EventsViewController: UICollectionViewController {
    
    //MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("Shows", comment: "Shows")
        
        self.eventsDataSource = EventsDataSource(location: nil)
        
        if LocationManager.isAuthorized {
            self.updateLocation()
        } else {
            self.showEnableLocationServicesMessage()
        }
        
        if let collectionView = self.collectionView {
            collectionView.backgroundColor = .white
            collectionView.contentInset.left = 20
            collectionView.contentInset.right = 20
            EventCardCell.registerCell(in: collectionView)
            CollectionTitleHeaderView.registerSupplementaryView(in: collectionView, as: UICollectionElementKindSectionHeader)
            
            if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                flowLayout.headerReferenceSize = CGSize(width: 100, height: 40)
                let width = collectionView.frame.size.width - (collectionView.contentInset.left + collectionView.contentInset.right)
                
                flowLayout.estimatedItemSize = CGSize(width: width, height: 500)
            }
        }        
    }
    
    override func viewWillLayoutSubviews() {
        
        guard let collectionView = self.collectionView else {
            super.viewWillLayoutSubviews()
            return
        }
        
        let topInset: CGFloat
        let bottomInset: CGFloat
        if #available(iOS 11, *) {
            topInset = collectionView.safeAreaInsets.top
            bottomInset = collectionView.safeAreaInsets.bottom
        } else {
            topInset = collectionView.contentInset.top
            bottomInset = 0
        }
        
        collectionView.backgroundView?.layoutMargins.top = topInset
        collectionView.backgroundView?.layoutMargins.bottom = bottomInset

        super.viewWillLayoutSubviews()
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        if identifier == "showEvent" {
            guard let eventViewController = segue.destination as? EventDetailsViewController else { return }
            guard let event = sender as? DiscoveryEvent else { return }
            eventViewController.event = event
        }
    }
    
    //MARK: -  Private Variables
    
    fileprivate let locationManager = LocationManager()
    fileprivate var eventsDataSource: EventsDataSource!
}

// MARK: - CollectionView

extension EventsViewController: UICollectionViewDelegateFlowLayout {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.eventsDataSource.eventGroups.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = self.eventsDataSource.eventGroups[section]
        return section.events.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let eventCardCell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCardCell.reuseIdentifier, for: indexPath) as! EventCardCell
        let event = self.eventsDataSource.event(at: indexPath)
        
        eventCardCell.configure(with: event)
        
        return eventCardCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showEvent", sender: self.eventsDataSource.event(at: indexPath))
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionTitleHeaderView.reuseIdentifier, for: indexPath) as! CollectionTitleHeaderView
        
        let eventGroup = self.eventsDataSource.eventGroups[indexPath.section]
        header.configure(with: eventGroup.title)
        
        return header
    }
}

//MARK: - Private Methods

fileprivate extension EventsViewController {
    
    func updateLocation() {
        let _ = self.locationManager.requestAuthorization().then {
            self.showLoadingViewWithMessage(NSLocalizedString("Determining your location", comment: "Determining your location"))
            return self.locationManager.updateLocation()
        }.then { placemark -> Void in
            self.loadEvents(at: placemark)
        }.catch { error in
            if error is LocationManager.LocationManagerError {
                self.showEnableLocationServicesMessage()
            }
        }
    }
    
    func loadEvents(at location: CLPlacemark) {
        guard let coordinate = location.location?.coordinate else {
            self.showMessageViewWithMessage(NSLocalizedString("Failed to load events for your location", comment: "Failed to load events for your location"))
            return
        }
        
        self.showLoadingEventsMessage(for: location)
        
        self.eventsDataSource = EventsDataSource(location: coordinate)
        self.eventsDataSource.reload().then { (eventGroups) -> () in
            guard eventGroups.isEmpty == false else {
                let year = Calendar.current.component(.year, from: Date())
                let message = NSLocalizedString("There are currently no events scheduled for the \(year)", comment: "Empty message for events this year")
                self.showMessageViewWithMessage(message)
                return
            }
            
            self.collectionView?.backgroundView = nil
            self.collectionView?.reloadData()
            
        }.catch { (error) in
            self.showFailedToLoadEventsMessage()
        }
    }
}

//MARK: - BackgroundView Helpers

fileprivate extension EventsViewController {
    
    //MARK: Messages
    
    func showEnableLocationServicesMessage() {
        let action = LocationManager.canRequestAuthorization ? self.requestLocationAuthorizationAction : self.openSettingsAction
        self.showMessageViewWithMessage("ShowsInTown uses your location to find shows near you", action: action)
    }
    
    func showFailedToLoadEventsMessage() {
        
        let retryAction = MessageView.Action(title: NSLocalizedString("Retry", comment: "Retry"), handler: {
            guard let location = self.locationManager.currentLocation else { return }
            self.loadEvents(at: location)
        })
        
        self.showMessageViewWithMessage(NSLocalizedString("Failed to load events", comment: "Failed to load events error message"), action: retryAction)
    }
    
    func showMessageViewWithMessage(_ message: String, action: MessageView.Action? = nil) {
        self.collectionView?.backgroundView = MessageView(message: message, action: action)
    }
    
    //MARK: Loading
    
    func showLoadingEventsMessage(for location: CLPlacemark) {
        let message: String
        if let cityStateText = location.cityStateText {
            message = NSLocalizedString("Looking for events in \(cityStateText)", comment: "Loading text with city text")
        } else {
            message = NSLocalizedString("Looking for events", comment: "Loading text without city text")
        }
        
        self.showLoadingViewWithMessage(message)
    }
    
    func showLoadingViewWithMessage(_ message: String?) {
        let loadingView = LoadingView()
        loadingView.startAnimating()
        loadingView.text = message
        self.collectionView?.backgroundView = loadingView
    }
    
    //MARK: Private Helpers
    
    private var requestLocationAuthorizationAction: MessageView.Action {
        return MessageView.Action(title: NSLocalizedString("Enable Location Services", comment: "Request access to location services"), handler: {
            self.updateLocation()
        })
    }
    
    private var openSettingsAction: MessageView.Action {
        return MessageView.Action(title: NSLocalizedString("Open Settings", comment: "Open Settings for this app"), handler: {
            if let url = URL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                self.updateLocation()
            }
        })
    }
}

//MARK: - EventDataSource Extension

fileprivate extension EventsDataSource {
    func event(at indexPath: IndexPath) -> DiscoveryEvent {
        return self.eventGroups[indexPath.section].events[indexPath.item]
    }
}
