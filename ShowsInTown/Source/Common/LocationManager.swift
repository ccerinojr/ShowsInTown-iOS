//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import UIKit
import CoreLocation
import PromiseKit

class LocationManager: NSObject {
    
    enum LocationManagerError: Error {
        case unauthorized
        case unableToDetermineAuthorizationStatus
        case noLocationsAvailable
        case failedToResolveLocation
    }
    
    typealias UpdateLocationCompletionHandler = (_ placemark: CLPlacemark?) -> ()
    typealias AuthorizationRequestCompletionHandler = (_ authorized: Bool) -> ()
    fileprivate(set) var currentLocation: CLPlacemark?
    
    static var isAuthorized: Bool {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        default:
            return false
        }
    }
    
    static var canRequestAuthorization: Bool {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            return true
        default:
            return false
        }
    }
    
    override init() {
        
        if let placemarkData = UserDefaults.standard.value(forKey: LocationManager.cachedLocationKey) as? Data, let cachedPlacemark = NSKeyedUnarchiver.unarchiveObject(with: placemarkData) as? CLPlacemark {
            self.currentLocation = cachedPlacemark
        } else {
            self.currentLocation = nil
        }
        
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    }

    func requestAuthorization() -> Promise<Void> {
        self.pendingAuthorization?.reject(NSError.cancelledError())
        let p = Promise<Void>.pending()
        self.pendingAuthorization = p
        self.locationManager.requestWhenInUseAuthorization()
        return p.promise
    }
    
    func updateLocation() -> Promise<CLPlacemark> {
        guard LocationManager.isAuthorized else {
            return Promise { fullfil, reject in
                reject(LocationManagerError.unauthorized)
            }
        }
        
        if let pendingLocationUpdate = self.pendingLocationUpdate {
            return pendingLocationUpdate.promise
        }
        
        let pendingPromise = Promise<CLPlacemark>.pending()
        self.pendingLocationUpdate = pendingPromise

        if self.appSettings.useAlertnateLocation {
            self.reverseGeocodeLocation(self.appSettings.alternateLocation)
        } else {
            locationManager.requestLocation()
        }
        
        return pendingPromise.promise
    }

    //MARK: - Private
    
    fileprivate static let cachedLocationKey = "location"

    fileprivate let locationManager = CLLocationManager()
    fileprivate let gecoder = CLGeocoder()
    fileprivate var pendingAuthorization: Promise<Void>.PendingTuple?
    fileprivate var pendingLocationUpdate: Promise<CLPlacemark>.PendingTuple?
    fileprivate let appSettings = AppSettings()
    fileprivate var isResolvingLocation = false
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let pendingPromise = self.pendingLocationUpdate else { return }
        guard let location = locations.first else {
            pendingPromise.reject(LocationManagerError.noLocationsAvailable)
            self.pendingLocationUpdate = nil
            return
        }
        
        self.reverseGeocodeLocation(location)
    }
    
    func reverseGeocodeLocation(_ location: CLLocation) {
        guard let pendingPromise = self.pendingLocationUpdate else { return }
        gecoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard let placemark = placemarks?.first else {
                pendingPromise.reject(LocationManagerError.noLocationsAvailable)
                self.pendingLocationUpdate = nil
                return
            }
            
            let archivedPlaceMark = NSKeyedArchiver.archivedData(withRootObject: placemark)
            UserDefaults.standard.set(archivedPlaceMark, forKey: LocationManager.cachedLocationKey)
            self.currentLocation = placemark
            
            pendingPromise.fulfill(placemark)
            self.pendingLocationUpdate = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let pendingPromise = self.pendingLocationUpdate else { return }
        pendingPromise.reject(LocationManagerError.failedToResolveLocation)
        self.pendingLocationUpdate = nil
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard let pendingPromise = self.pendingAuthorization, status != .notDetermined else { return }
        
        if LocationManager.isAuthorized == false {
            pendingPromise.reject(LocationManagerError.unauthorized)
        } else {
            pendingPromise.fulfill(())
        }
        
        self.pendingAuthorization = nil
    }
}
