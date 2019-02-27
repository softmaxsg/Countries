//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Countries

extension CountryListItemViewModelProtocol {
    
    func isEqual(to country: Country) -> Bool {
        guard name == country.name else { return false }
        guard nativeName == country.nativeName else { return false }
        
        let expectedFlagUrl = URL(string: "https://flagpedia.net/data/flags/small/\(country.countryCode2.lowercased()).png")!
        guard flagUrl == expectedFlagUrl else { return false }
        
        let formatter = numberFormatter()
        
        let expectedPopulation = formatter.string(from: NSNumber(value: country.population))!
        guard population == expectedPopulation else { return false }

        let expectedAreaSize = "\(formatter.string(from: NSNumber(value: country.areaSize))!) km\u{B2}"
        guard areaSize == expectedAreaSize else { return false }
        
        return true
    }
    
}

extension CountryListItemViewModelProtocol {
    
    private func numberFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        formatter.usesGroupingSeparator = true
        return formatter
    }

}
