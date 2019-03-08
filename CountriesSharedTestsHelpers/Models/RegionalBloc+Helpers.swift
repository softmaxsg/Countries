//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
import CountriesShared

extension RegionalBloc {
    
    public static func random(acronym: String = .random(),
                              name: String = .random()) -> RegionalBloc {
        return RegionalBloc(
            acronym: acronym,
            name: name
        )
    }
    
}

extension RegionalBloc: JSONPresentable {
    
    public func JSON() -> [String: Any] {
        return [
            "acronym": acronym,
            "name": name,
        ]
    }
    
}
