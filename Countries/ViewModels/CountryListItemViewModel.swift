//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

protocol CountryListItemViewModelProtocol: CountryBriefDetailsViewModelProtocol {
}

final class CountryListItemViewModel: CountryListItemViewModelProtocol {

    private let briefDetails: CountryBriefDetailsViewModel
    
    var name: String { return briefDetails.name }
    var population: String { return briefDetails.population }
    var areaSize: String { return briefDetails.areaSize }
    var flagUrl: URL { return briefDetails.flagUrl }
    
    init(country: Country) {
        briefDetails = CountryBriefDetailsViewModel(country: country)
    }
    
}
