//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Countries

extension Location {
    
    static func random(coordinate: Location.Coordinate = .random(),
                       countryCode: String = .random()) -> Location {
        return Location(
            coordinate: coordinate,
            countryCode: countryCode
        )
    }
    
}


extension Location.Coordinate {
    
    static func random() -> Location.Coordinate {
        return Location.Coordinate(
            latitude: Double.random(in: -180...180),
            longitude: Double.random(in: -180...180)
        )
    }
    
}
