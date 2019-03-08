//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
import CountriesShared

public final class CountryStorageServiceMock: CountryStorageServiceProtocol {
    
    public typealias LoadCountryImpl = () -> Country?
    public typealias SaveCountryImpl = (Country?) -> Void

    private let loadCountryImpl: LoadCountryImpl
    private let saveCountryImpl: SaveCountryImpl

    public init(loadCountry loadCountryImpl: @escaping LoadCountryImpl,
                saveCountry saveCountryImpl: @escaping SaveCountryImpl) {
        self.loadCountryImpl = loadCountryImpl
        self.saveCountryImpl = saveCountryImpl
    }

    public func loadCountry() -> Country? {
        return loadCountryImpl()
    }
    
    public func saveCountry(_ country: Country?) {
        saveCountryImpl(country)
    }

}

extension CountryStorageServiceMock {
    
    public static var empty: CountryStorageServiceMock {
        return CountryStorageServiceMock(loadCountry: { return nil }, saveCountry: { _ in })
    }
    
}
