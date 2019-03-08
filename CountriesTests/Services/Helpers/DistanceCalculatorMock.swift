//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
import CountriesShared
@testable import Countries

final class DistanceCalculatorMock: DistanceCalculatorProtocol {

    typealias DistanceImpl = (Coordinate, Country) -> Double
    
    private let distanceImpl: DistanceImpl
    
    init(distance distanceImpl: @escaping DistanceImpl) {
        self.distanceImpl = distanceImpl
    }
    
    func distance(from coordinate: Coordinate, to country: Country) -> Double {
        return distanceImpl(coordinate, country)
    }

}
