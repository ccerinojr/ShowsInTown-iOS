//
//  Copyright © 2018 Carmen Cerino. All rights reserved.
//

import Foundation

struct ITunesLookupResponse<T: Decodable & ITunesObjectWrapperType>: Decodable {
    let results: [T]
    
    private enum CodingKeys: String, CodingKey {
        case results
    }
    
    private enum WrapperKeys: String, CodingKey {
        case wrapperType
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var typeContainer = try container.nestedUnkeyedContainer(forKey: .results)
        var objectsContainer = typeContainer
        var results = [T]()
        
        
        while(!typeContainer.isAtEnd) {
            let wrapperObjectContainer = try typeContainer.nestedContainer(keyedBy: WrapperKeys.self)
            
            let wrapperType = try wrapperObjectContainer.decode(String.self, forKey: .wrapperType)
            if wrapperType == T.nameOfType {
                let decodedObject = try objectsContainer.decode(T.self)
                results.append(decodedObject)
            } else {
                let _ = try objectsContainer.nestedContainer(keyedBy: WrapperKeys.self)
            }
        }

        self.results = results
    }
}
