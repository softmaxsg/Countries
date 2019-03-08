//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
import CountriesShared

extension Coordinate {
    
    public static func random() -> Coordinate {
        return Coordinate(
            latitude: Double.random(in: -180...180),
            longitude: Double.random(in: -180...180)
        )
    }
    
}
