//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

extension String {
    
    public static func random() -> String {
        return UUID.random().uuidString
    }
    
}
