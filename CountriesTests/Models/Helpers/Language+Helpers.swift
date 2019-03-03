//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Countries

extension Language {
    
    static func random(languageCode2: String? = .random(),
                       languageCode3: String = .random(),
                       name: String = .random(),
                       nativeName: String = .random()) -> Language {
        return Language(
            languageCode2: languageCode2,
            languageCode3: languageCode3,
            name: name,
            nativeName: nativeName
        )
    }
    
}

extension Language: JSONPresentable {
    
    func JSON() -> [String: Any] {
        return [
            "iso639_1": languageCode2 as Any,
            "iso639_2": languageCode3,
            "name": name,
            "nativeName": nativeName,
        ]
    }
    
}
