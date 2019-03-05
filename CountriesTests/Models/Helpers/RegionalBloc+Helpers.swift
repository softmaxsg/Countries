//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Countries

extension RegionalBloc {
    
    static func random(acronym: String = .random(),
                       name: String = .random()) -> RegionalBloc {
        return RegionalBloc(
            acronym: acronym,
            name: name
        )
    }
    
}

extension RegionalBloc: JSONPresentable {
    
    func JSON() -> [String: Any] {
        return [
            "acronym": acronym,
            "name": name,
        ]
    }
    
}
