//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Countries

final class CountryStorageServiceMock: CountryStorageServiceProtocol {
    
    typealias LoadCountryImpl = () -> Country?
    typealias SaveCountryImpl = (Country?) -> Void

    private let loadCountryImpl: LoadCountryImpl
    private let saveCountryImpl: SaveCountryImpl

    init(loadCountry loadCountryImpl: @escaping LoadCountryImpl,
         saveCountry saveCountryImpl: @escaping SaveCountryImpl) {
        self.loadCountryImpl = loadCountryImpl
        self.saveCountryImpl = saveCountryImpl
    }

    func loadCountry() -> Country? {
        return loadCountryImpl()
    }
    
    func saveCountry(_ country: Country?) {
        saveCountryImpl(country)
    }

}

extension CountryStorageServiceMock {
    
    static var empty: CountryStorageServiceMock {
        return CountryStorageServiceMock(loadCountry: { return nil }, saveCountry: { _ in })
    }
    
}
