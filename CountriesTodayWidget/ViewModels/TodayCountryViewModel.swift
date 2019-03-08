//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
import CountriesShared

enum UpdateResult {
    
    case new
    case same
    case error
    
}

protocol TodayCountryViewModelProtocol {

    var details: CountryDetailsViewModelProtocol? { get }
    
    func updateCountry(completion handler: @escaping (UpdateResult) -> Void)
    
}

final class TodayCountryViewModel: TodayCountryViewModelProtocol {
    
    private let countryStorageService: CountryStorageServiceProtocol
    private let countriesProvider: CountriesProviderProtocol
    private let locationProvider: LocationProviderProtocol

    private var currentCountry: Country? {
        didSet {
            countryStorageService.saveCountry(currentCountry)
            details = currentCountry.map { CountryDetailsViewModel(country: $0) }
        }
    }

    private(set) var details: CountryDetailsViewModelProtocol?

    init(locationProvider: LocationProviderProtocol,
         countryStorageService: CountryStorageServiceProtocol,
         countriesProvider: CountriesProviderProtocol) {
        self.locationProvider = locationProvider
        self.countryStorageService = countryStorageService
        self.countriesProvider = countriesProvider
        
        defer { currentCountry = countryStorageService.loadCountry() }
    }

    func updateCountry(completion handler: @escaping (UpdateResult) -> Void) {
        locationProvider.requestLocation { [weak self] result in
            guard let countryCode = result.value?.countryCode else {
                self?.currentCountry = nil
                handler(.error)
                return
            }
            
            guard countryCode != self?.currentCountry?.countryCode2 else {
                handler(.same)
                return
            }
            
            self?.countriesProvider.load(with: countryCode) { [weak self] result in
                self?.currentCountry = result.value
                handler(.new)
            }
        }
    }
    
}
