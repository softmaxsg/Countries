//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

protocol CountryStorageServiceProtocol {
    
    func loadCountry() -> Country?
    func saveCountry(_ country: Country?)
    
}

final class CountryStorageService: CountryStorageServiceProtocol {
    
    private static let storageKey = "CurrentCountry"
    private let userDefaults: UserDefaultsProtocol
    private let jsonEncoder: JSONEncoderProtocol
    private let jsonDecoder: JSONDecoderProtocol
    
    init(userDefaults: UserDefaultsProtocol = UserDefaults(suiteName: Constants.sharedStorageName)!,
         jsonEncoder: JSONEncoderProtocol = JSONEncoder(),
         jsonDecoder: JSONDecoderProtocol = JSONDecoder()) {
        self.userDefaults = userDefaults
        self.jsonEncoder = jsonEncoder
        self.jsonDecoder = jsonDecoder
    }
    
    func loadCountry() -> Country? {
        return userDefaults.data(forKey: CountryStorageService.storageKey)
            .flatMap { try? jsonDecoder.decode(Country.self, from: $0) }
    }
    
    func saveCountry(_ country: Country?) {
        let data = country.flatMap { try? jsonEncoder.encode($0) }
        userDefaults.set(data, forKey: CountryStorageService.storageKey)
    }
    
}
