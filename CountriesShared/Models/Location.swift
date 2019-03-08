//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

public struct Location: Equatable {

    public let coordinate: Coordinate
    public let countryCode: String?
    
    public init(coordinate: Coordinate, countryCode: String?) {
        self.coordinate = coordinate
        self.countryCode = countryCode
    }
    
}
