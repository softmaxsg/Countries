//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Countries

extension Country {
    
    static func random(countryCode2: String = .random(),
                       name: String = .random(),
                       nativeName: String = .random(),
                       population: UInt64 = .random(in: 1..<10_000_000_000),
                       areaSize: Double = .random(in: 1..<100_000_000)) -> Country {
        return Country(
            countryCode2: countryCode2,
            name: name,
            nativeName: nativeName,
            population: population,
            areaSize: areaSize
        )
    }
    
}

extension Country: JSONPresentable {
    
    func JSON() -> [String: Any] {
        return [
            "alpha2Code": countryCode2,
            "name": name,
            "nativeName": nativeName,
            "population": population,
            "area": areaSize as Any,
        ]
    }
    
}
