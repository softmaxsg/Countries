//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import XCTest
import CountriesShared
import CountriesSharedTestsHelpers
@testable import Countries

final class CountryViewCellTests: CountryDetailsViewTestCase {
    
    private lazy var cell: CountryViewCell = {
        let cell = CountryViewCell()
        cell.briefCountryView?.imageLoader = imageLoaderMock
        return cell
    }()
    
    func testNormalAppearance() {
        let cell = self.cell
        cell.configure(with: CountryListItemViewModel(country: .random(
            countryCode2: countryCode,
            name: countryName,
            nativeName: countryNativeName,
            population: countryPopulation,
            areaSize: countryAreaSize
        )))
        
        adjustSize(for: cell)
        snapshotVerifyView(cell)
    }
    
    func testNoAreaSizeAppearance() {
        let cell = self.cell
        cell.configure(with: CountryListItemViewModel(country: .random(
            countryCode2: countryCode,
            name: countryName,
            nativeName: countryNativeName,
            population: countryPopulation,
            areaSize: nil
        )))
        
        adjustSize(for: cell)
        snapshotVerifyView(cell)
    }

}
