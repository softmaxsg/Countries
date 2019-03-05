//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Countries

extension Currency {
    
    static func random(code: String? = .random(),
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
    
    func JSON() -> [String: Any] {
        return [
            "code": code as Any,
            "name": name as Any,
            "symbol": symbol as Any,
        ]
    }
    
}
