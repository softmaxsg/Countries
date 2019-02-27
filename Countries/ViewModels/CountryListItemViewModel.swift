//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

protocol CountryListItemViewModelProtocol {

    var name: String { get }
    var nativeName: String { get }
    var population: String { get }
    var areaSize: String { get }
    var flagUrl: URL { get }

}

final class CountryListItemViewModel: CountryListItemViewModelProtocol {

    let name: String
    let nativeName: String
    let population: String
    let areaSize: String
    let flagUrl: URL
    
    init(country: Country) {
        name = country.name
        nativeName = country.nativeName
        flagUrl = URL(string: "https://flagpedia.net/data/flags/small/\(country.countryCode2.lowercased()).png")!
        
        let formatter = CountryListItemViewModel.numberFormatter()
        population = formatter.string(from: NSNumber(value: country.population))!
        areaSize = "\(formatter.string(from: NSNumber(value: country.areaSize))!) km\u{B2}"
    }
    
}

extension CountryListItemViewModel {
    
    private class func numberFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        formatter.usesGroupingSeparator = true
        return formatter
    }
    
}
