//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
import CountriesShared

extension Location {
    
    public static func random(coordinate: Coordinate = .random(),
                              countryCode: String = .random()) -> Location {
        return Location(
            coordinate: coordinate,
            countryCode: countryCode
        )
    }
    
}

