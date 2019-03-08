//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

extension Data {
    
    public static func random() -> Data {
        return String.random().data(using: .utf8)!
    }
    
}
