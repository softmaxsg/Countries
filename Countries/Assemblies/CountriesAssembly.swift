//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

final class CountriesAssembly {
    
    func countriesViewModel(delegate: CountryListViewModelDelegate) -> CountryListViewModel {
        return CountryListViewModel(
            delegate: delegate,
            countriesProvider: CountriesProvider(),
            filteringService: FilteringService()
        )
    }
    
}
