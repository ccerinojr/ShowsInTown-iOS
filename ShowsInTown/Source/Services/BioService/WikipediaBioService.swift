//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import Foundation
import PromiseKit

struct WikipediaBioService: AttractionBioService {
    
    enum AttractionBioServiceError: Error {
        case attractionNotSupported
        case bioUnavailable
    }
    
    init(session: URLSession) {
        self.session = session
    }
    
    func isSupported(_ attraction: Attraction) -> Bool {
        return attraction.externalLinks[.wiki] != nil
    }
    
    func bio(for attraction: Attraction) -> Promise<String> {
        guard let wikipediaURL = attraction.externalLinks[.wiki]?.first, let title = wikipediaURL.path.components(separatedBy: "/").last else {
            return Promise<String>(error: AttractionBioServiceError.bioUnavailable)
        }
        
        return self.fetchBioFromtWikipedia(forTitle: title)
    }
    
    private func fetchBioFromtWikipedia(forTitle title: String, isFromKatana: Bool = false) -> Promise<String> {
        
        var url = URLComponents(string: "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro=&redirect=&explaintext=")!
        url.appendQueryItems([URLQueryItem(name: "titles", value: title)])
        let queryURL = url.url!
        
        let fetchBio: URLDataPromise = self.session.dataTask(with: URLRequest(url: queryURL))
        return fetchBio.asDictionary().then { (json) -> Promise<String> in
            guard let query = json["query"] as? [String: Any], let pages = query["pages"] as? [String: Any] else { return Promise<String>(error: AttractionBioServiceError.bioUnavailable) }
            guard let firstPageKey = pages.keys.first, let page = pages[firstPageKey] as? [String: Any], let bio = page["extract"] as? String, bio.isEmpty == false else {
                return Promise<String>(error: AttractionBioServiceError.bioUnavailable)
            }
            
            return Promise<String>(value: bio.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression))
            
        }.recover(execute: { (error) -> Promise<String> in
            throw AttractionBioServiceError.bioUnavailable
        })
    }
    
    //MARK:
    private let session: URLSession
}
