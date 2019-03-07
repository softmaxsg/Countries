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

protocol CurrentCountryViewModelProtocol: class {

    var viewMode: CurrentCountryViewMode { get set }
    var details: CountryDetailsViewModelProtocol { get }
    
}

final class CurrentCountryViewModel: CurrentCountryViewModelProtocol {
    
    let details: CountryDetailsViewModelProtocol
    
    weak var delegate: CurrentCountryViewModelDelegate?
    var viewMode = CurrentCountryViewMode.compact { didSet { delegate?.viewModeDidChange() } }
    
    init(delegate: CurrentCountryViewModelDelegate, country: Country) {
        self.delegate = delegate
        details = CountryDetailsViewModel(country: country)
    }
    
}
