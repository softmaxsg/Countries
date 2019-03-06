//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

enum CurrentCountryViewMode {
    
    case compact
    case expanded
    
}

protocol CurrentCountryViewModelDelegate: class {
    
    func viewModeDidChange()
    
}

protocol CurrentCountryViewModelProtocol: class, CountryDetailsProtocol {

    var viewMode: CurrentCountryViewMode { get set }
    
}

final class CurrentCountryViewModel: CurrentCountryViewModelProtocol {
    
    private let details: CountryDetailsViewModel
    
    weak var delegate: CurrentCountryViewModelDelegate?
    var viewMode = CurrentCountryViewMode.compact { didSet { delegate?.viewModeDidChange() } }
    
    var name: String { return details.name }
    var population: String { return details.population }
    var areaSize: String { return details.areaSize }
    var flagUrl: URL { return details.flagUrl }

    var capital: String { return details.capital }
    var region: String { return details.region }
    var regionalBlocs: String { return details.regionalBlocs }
    var languages: String { return details.languages }
    var currencies: String { return details.currencies }

    init(delegate: CurrentCountryViewModelDelegate, country: Country) {
        self.delegate = delegate
        details = CountryDetailsViewModel(country: country)
    }
    
}
