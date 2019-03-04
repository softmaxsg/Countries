//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Countries

extension Location {
    
    static func random(coordinate: Coordinate = .random(),
                       countryCode: String = .random()) -> Location {
        return Location(
            coordinate: coordinate,
            countryCode: countryCode
        )
    }
    
}

