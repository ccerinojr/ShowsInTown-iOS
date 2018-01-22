//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import Foundation
import PromiseKit

struct ITunesTrackProvider: TrackProvider {
    
    var trackCount: UInt = 3
    
    init(session: URLSession) {
        self.session = session
    }
    
    func isSupported(_ attraction: Attraction) -> Bool {
        return attraction.externalIdentifiers[.itunes] != nil
    }

    func tracks(for attraction: Attraction, limit: UInt) -> Promise<[Track]> {
        guard let itunesIdentifier = attraction.externalIdentifiers[.itunes]?.first else {
            return Promise<[Track]>(error: TrackProviderError.attractionNotSupported)
        }
        
        return self.fetchTracks(forItunesID: itunesIdentifier, limit: limit)
    }
    
    //MARK: - Private Variables
    private let session: URLSession
    fileprivate var itunesBaseURL = URLComponents(string: "https://itunes.apple.com/lookup")!
    
    private func fetchTracks(forItunesID artistID: String, limit: UInt) -> Promise<[Track]> {
        var components = self.itunesBaseURL
        
        let idItem = URLQueryItem(name: "id", value: artistID)
        let limitItem = URLQueryItem(name: "limit", value: String(limit))
        let entityItem = URLQueryItem(name: "entity", value: "song")
        let sortItem = URLQueryItem(name: "sort", value: "recent,popularity")
        
        let currentItems = components.queryItems ?? []
        components.queryItems = currentItems + [idItem, limitItem, entityItem, sortItem]
        
        let url = components.url!
        
        let fetchTracks: URLDataPromise = self.session.dataTask(with: URLRequest(url: url))
        
        return fetchTracks.asDataAndResponse().then { (data, response) -> [Track] in
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(ITunesLookupResponse<ITunesTrack>.self, from: data)
                return response.results
            } catch {
                throw TrackProviderError.failedToParse
            }
        }.recover(execute: { (error) -> [Track] in
            
            if error is JSONError {
                return []
            }
            
            throw TrackProviderError.failedToFetch
        })
    }
}
