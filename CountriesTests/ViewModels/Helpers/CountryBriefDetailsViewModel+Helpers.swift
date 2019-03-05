//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Countries

extension CountryBriefDetailsProtocol {
    
    func isEqual(to country: Country) -> Bool {
        guard name == country.name else { return false }
        
        let expectedFlagUrl = URL(string: "https://flagpedia.net/data/flags/small/\(country.countryCode2.lowercased()).png")!
        guard flagUrl == expectedFlagUrl else { return false }
        
        let formatter = numberFormatter()
        
        let expectedPopulation = formatter.string(from: NSNumber(value: country.population))!
        guard population == expectedPopulation else { return false }
        
        let expectedAreaSize = country.areaSize.flatMap { "\(formatter.string(from: NSNumber(value: $0))!) km\u{B2}" } ?? ""
        guard areaSize == expectedAreaSize else { return false }
        
        return true
    }
    
}

extension CountryBriefDetailsProtocol {
    
    private func numberFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        formatter.usesGroupingSeparator = true
        return formatter
    }
    
}
