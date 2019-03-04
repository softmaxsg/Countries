//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import XCTest
@testable import Countries

final class SortingServiceTests: XCTestCase {

    func testSorting() {
        let expectedCoordinate = Coordinate.random()
        
        let countries: [Country] = .random(maxCount: 200) { .random() }
        let distances = Dictionary<String, Double>(uniqueKeysWithValues: countries.map { country in
            (key: country.countryCode2, value: .random(in: 0..<Double.greatestFiniteMagnitude))
        })
        
        let distanceCalculator = DistanceCalculatorMock { coordinate, country in
            XCTAssertEqual(coordinate, expectedCoordinate)
            return distances[country.countryCode2]!
        }
        
        let sortingServie = SortingService(distanceCalculator: distanceCalculator)
        let result = sortingServie.sorted(countries, coordinate: expectedCoordinate)
        
        let sortedCountryCodes = result.map { $0.countryCode2 }
        let exptectedResult = distances.sorted { $0.value < $1.value }.map { $0.key }
        
        XCTAssertEqual(sortedCountryCodes, exptectedResult)
    }
    
}
