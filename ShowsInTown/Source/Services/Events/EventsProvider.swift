//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import Foundation
import CoreLocation
import PromiseKit

enum Response<T> {
    case success(response: T)
    case failure(error: Error)
}

class EventsProvider  {
    
    static let formatter = ISO8601DateFormatter()
    typealias RequestCancelationHandler = () -> ()

    init(session: URLSession) {
        self.session = session
    }
    
    func events(near location: CLLocationCoordinate2D, radius: CLLocationDistance, dateRange: DateInterval? = nil) -> Promise<[DiscoveryEvent]> {
        let pendingPromise = Promise<[DiscoveryEvent]>.pending()
        
        let _ = self.events(near: location, radius: radius, dateRange: dateRange) { (response) in
            switch response {
            case .failure(let error):
                pendingPromise.reject(error)
            case .success(let events):
                pendingPromise.fulfill(events)
            }
        }
        
        return pendingPromise.promise
    }
    
    func events(near location: CLLocationCoordinate2D, radius: CLLocationDistance, dateRange: DateInterval? = nil, completion: @escaping (_ response: Response<[DiscoveryEvent]>) -> ()) -> RequestCancelationHandler {
        
        var searchURL = self.discoveryBaseURL
        
        let locationQueryItem = URLQueryItem(name: "latlong", value: "\(location.latitude),\(location.longitude)")
        let radiusItem = URLQueryItem(name: "radius", value: "\(Int(radius))")
        let sizeItem = URLQueryItem(name: "size", value: "100")
        let sortItem = URLQueryItem(name: "sort", value: "date,asc")
        let classificationItem = URLQueryItem(name: "classificationName", value: "Music")
        let promoterId = URLQueryItem(name: "promoterId", value: liveNationPromoterId)
        var queryParameters = [locationQueryItem, radiusItem, sizeItem, sortItem, classificationItem, promoterId]

        if let dateRange = dateRange {
            queryParameters.append(URLQueryItem(name: "startDateTime", value: EventsProvider.formatter.string(from: dateRange.start)))
            queryParameters.append(URLQueryItem(name: "endDateTime", value: EventsProvider.formatter.string(from: dateRange.end)))
        }
        
        let existingItems = searchURL.queryItems ?? []
        searchURL.queryItems = queryParameters + existingItems
        
        let task = self.session.dataTask(with: searchURL.url!) { (data, _, error) in
            
            if let error = error {
                let cancelError = error as NSError
                guard cancelError.code != NSURLErrorCancelled else { return }
                
                completion(.failure(error: error))
                return
            }
            
            guard let data = data else {
                completion(.failure(error: ServiceError.noData))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(DiscoveryEventSearchResponse.self, from: data)
                let eventsWithFilteredAttractions = response.events.map { (event) -> (DiscoveryEvent) in
                    
                    let attractions = event.attractions.filter({ (attraction) -> Bool in
                        let containsEventTypeClassification = attraction.classifications.contains(where: { (classification) -> Bool in
                            guard let typeJSON = classification["type"] as? [String: String] else { return false }
                            return typeJSON["id"] == "KZAyXgnZfZ7v7lt"
                        })
                        return containsEventTypeClassification == false
                    })
                    
                    return DiscoveryEvent(identifier: event.identifier, name: event.name, webURL: event.webURL, locale: event.locale, date: event.date, attractions: attractions, venues: event.venues, images: event.images, isTest: event.isTest)

                }
                
                completion(.success(response: eventsWithFilteredAttractions))
                
            } catch(let e) {
                print(e)
                completion(.failure(error: ServiceError.jsonDeserializationFailed))
            }
        }
        
        task.resume()
        
        let cancel = {
            task.cancel()
        }
        
        return cancel
    }
    
    //MARK: - Private
    
    fileprivate let discoveryBaseURL: URLComponents = {
        var components = URLComponents(string: "https://app.ticketmaster.com/discovery/v2/events.json")!
        
        let apiKey = URLQueryItem(name: "apikey", value: "tVfYMGEZ5RUM83hrSMkOBXhjqx76xLS9")
        components.queryItems = [apiKey]

        return components
    }()
    
    fileprivate let session: URLSession
    fileprivate let liveNationPromoterId = "653"
    fileprivate let appSettings = AppSettings()
}
