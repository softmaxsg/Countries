//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
import CountriesShared

final class CountriesAssembly {
    
    func countriesViewModel(delegate: CountryListViewModelDelegate) -> CountryListViewModel {
        return CountryListViewModel(
            delegate: delegate,
            countriesProvider: CountriesProvider(),
            locationProvider: LocationProvider(),
            sortingService: SortingService(),
            filteringService: FilteringService(),
            countryStorageService: CountryStorageService()
        )
    }
    
}
