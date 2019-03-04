//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
import CoreLocation

struct Location: Equatable {

    struct Coordinate: Equatable {
        
        let latitude: Double
        let longitude: Double
        
    }

    let coordinate: Coordinate
    let countryCode: String?
    
}

extension Location.Coordinate {
    
    init(_ coordinate: CLLocationCoordinate2D) {
        latitude = coordinate.latitude
        longitude = coordinate.longitude
    }
    
}
