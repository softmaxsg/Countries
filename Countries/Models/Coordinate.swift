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
    
    var isValid: Bool {
        return (-180.0...180.0).contains(latitude) && (-180.0...180.0).contains(longitude)
    }
    
}

extension Coordinate {
    
    init(_ coordinate: CLLocationCoordinate2D) {
        latitude = coordinate.latitude
        longitude = coordinate.longitude
    }
    
}

extension Coordinate: Codable {

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let values = try container.decode([Double].self)
        guard values.count == 2 else {
            latitude = .greatestFiniteMagnitude
            longitude = .greatestFiniteMagnitude
            return
        }
        
        latitude = values[0]
        longitude = values[1]
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(isValid ? [latitude, longitude] : [])
    }

}
