//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
import CoreLocation

struct Coordinate: Equatable {
    
    let latitude: Double
    let longitude: Double
    
}

extension Coordinate {
    
    init(_ coordinate: CLLocationCoordinate2D) {
        latitude = coordinate.latitude
        longitude = coordinate.longitude
    }
    
}
