//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
import CountriesShared

protocol SortingServiceProtocol {
    
    func sorted(_ countries: [Country], coordinate: Coordinate) -> [Country]
    
}

final class SortingService: SortingServiceProtocol {
    
    private let distanceCalculator: DistanceCalculatorProtocol
    
    init(distanceCalculator: DistanceCalculatorProtocol = DistanceCalculator()) {
        self.distanceCalculator = distanceCalculator
    }
    
    func sorted(_ countries: [Country], coordinate: Coordinate) -> [Country] {
        return countries.sorted { country1, country2 in
            let distance1 = distanceCalculator.distance(from: coordinate, to: country1)
            let distance2 = distanceCalculator.distance(from: coordinate, to: country2)
            return distance1 < distance2
        }

    }
    
}
