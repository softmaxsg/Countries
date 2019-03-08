//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import XCTest
import CoreLocation
import CountriesShared
import CountriesSharedTestsHelpers
@testable import Countries

final class DistanceCalculatorTests: XCTestCase {
    
    func testDistanceCalculation() {
        let coordinate = Coordinate.random()
        let country = Country.random()
        
        let calculator = DistanceCalculator()
        let distance = calculator.distance(from: coordinate, to: country)
        
        let expectedDistance = self.distance(from: coordinate, to: country)
        XCTAssertEqual(distance, expectedDistance)
    }
    
    func testInvalidCoordinate() {
        let country = Country.random()
        let coordinate = Coordinate(
            latitude: Double.random(in: 181...200),
            longitude: Double.random(in: 181...200)
        )

        let calculator = DistanceCalculator()
        let distance = calculator.distance(from: coordinate, to: country)

        XCTAssertEqual(distance, Double.greatestFiniteMagnitude)
    }
    
    func testInvalidCountryCenter() {
        let coordinate = Coordinate.random()
        let country = Country.random(center: Coordinate(
            latitude: Double.random(in: 181...200),
            longitude: Double.random(in: 181...200)
        ))
        
        let calculator = DistanceCalculator()
        let distance = calculator.distance(from: coordinate, to: country)
        
        XCTAssertEqual(distance, Double.greatestFiniteMagnitude)
    }

}

extension DistanceCalculatorTests {
    
    // Calcuation implementation is just duplicated in order to test the correctness
    func distance(from coordinate: Coordinate, to country: Country) -> Double {
        guard coordinate.isValid, country.center.isValid else { fatalError() }
        
        let coordinateLocation = CLLocation(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )
        
        let countryCenterLocation = CLLocation(
            latitude: country.center.latitude,
            longitude: country.center.longitude
        )
        
        let distance = coordinateLocation.distance(from: countryCenterLocation) / 1000.0
        let countryRadius = country.areaSize.map { sqrt($0 / Double.pi) } ?? 0
        return max(distance - countryRadius, 0)
    }
    
}
