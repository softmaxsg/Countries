//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
import CountriesShared

final class TodayCountryAssembly {
    
    func todayCountryViewModel() -> TodayCountryViewModel {
        return TodayCountryViewModel(
            locationProvider: LocationProvider(),
            countryStorageService: CountryStorageService(),
            countriesProvider: CountriesProvider()
        )
    }
    
}
