//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
import CountriesShared

extension Currency {
    
    public static func random(code: String? = .random(),
                              name: String? = .random(),
                              symbol: String? = .random()) -> Currency {
        return Currency(
            code: code,
            name: name,
            symbol: symbol
        )
    }
    
}

extension Currency: JSONPresentable {
    
    public func JSON() -> [String: Any] {
        return [
            "code": code as Any,
            "name": name as Any,
            "symbol": symbol as Any,
        ]
    }
    
}
