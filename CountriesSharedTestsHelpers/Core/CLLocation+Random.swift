//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocation {
    
    public static func random() -> CLLocation {
        return CLLocation(
            latitude: CLLocationDegrees.random(in: -180...180),
            longitude: CLLocationDegrees.random(in: -180...180)
        )
    }

}
