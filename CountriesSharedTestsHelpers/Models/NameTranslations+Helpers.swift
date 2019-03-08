//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
import CountriesShared

extension NameTranslations {
    
    public static func random(count: Int = Int.random(in: 1...10)) -> NameTranslations {
        return NameTranslations(
            translations: Dictionary(uniqueKeysWithValues: Array(0..<count).map { _ in
                (key: String.random(), value: String.random())
            })
        )
    }
    
}

extension NameTranslations: JSONPresentable {
    
    public func JSON() -> [String: Any] {
        return translations
    }
    
}

