//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import Foundation
import CoreGraphics

public struct DiscoveryRemoteImage: Decodable {
    
    public enum Ratio : String, Codable {
        case sixteenByNine = "16_9"
        case fourByThree = "4_3"
        case threeByTwo = "3_2"
    }
    
    public let ratio : Ratio
    public let url :  URL
    public let size : CGSize
    public let isFallback : Bool
    
    public init(url: URL, size: CGSize, isFallback: Bool = false, ratio: Ratio) {
        self.url = url
        self.size = size
        self.isFallback = isFallback
        self.ratio = ratio
    }
}

public extension DiscoveryRemoteImage {
    
    private enum CodingKeys : String, CodingKey  {
        case ratio
        case url
        case isFallback = "fallback"
        case width
        case height
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.url = try container.decode(URL.self, forKey: .url)
        self.ratio = try container.decode(Ratio.self, forKey: .ratio)
        self.isFallback = try container.decode(Bool.self, forKey: .isFallback)
        
        let width = try container.decode(Double.self, forKey: .width)
        let height = try container.decode(Double.self, forKey: .height)
        
        self.size = CGSize(width: width, height: height)
    }
    
}
