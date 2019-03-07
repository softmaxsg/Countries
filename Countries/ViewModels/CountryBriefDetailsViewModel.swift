//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

protocol CountryBriefDetailsViewModelProtocol {
    
    var name: String { get }
    var population: String { get }
    var areaSize: String { get }
    var flagUrl: URL { get }
    
}

struct CountryBriefDetailsViewModel: CountryBriefDetailsViewModelProtocol {
    
    let name: String
    let population: String
    let areaSize: String
    let flagUrl: URL
    
    init(country: Country) {
        name = country.name
        flagUrl = Constants.countryFlagUrl(code: country.countryCode2)
        
        let formatter = CountryBriefDetailsViewModel.numberFormatter()
        population = formatter.string(from: NSNumber(value: country.population))!
        areaSize = country.areaSize.flatMap { "\(formatter.string(from: NSNumber(value: $0))!) km\u{B2}" } ?? ""
    }
    
}

extension CountryBriefDetailsViewModel {
    
    private static func numberFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        formatter.usesGroupingSeparator = true
        return formatter
    }
    
}
