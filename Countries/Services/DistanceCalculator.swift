//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
import CoreLocation

protocol DistanceCalculatorProtocol {
    
    func distance(from coordinate: Coordinate, to country: Country) -> Double
    
}

final class DistanceCalculator: DistanceCalculatorProtocol {

    func distance(from coordinate: Coordinate, to country: Country) -> Double {
        guard coordinate.isValid, country.center.isValid else { return .greatestFiniteMagnitude }
        
        let coordinateLocation = CLLocation(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )
        
        let countryCenterLocation = CLLocation(
            latitude: country.center.latitude,
            longitude: country.center.longitude
        )
        
        let distance = coordinateLocation.distance(from: countryCenterLocation) / 1000.0

        // Using country radius has to improve distance calculation to large countries
        let countryRadius = country.areaSize.map { sqrt($0 / Double.pi) } ?? 0
        return max(distance - countryRadius, 0)
    }
    
}
