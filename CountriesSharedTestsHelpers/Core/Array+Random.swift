//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

extension Array {

    public static func random(minCount: Int = 1, maxCount: Int, newElement: () -> Element) -> [Element] {
        return (minCount...Int.random(in: minCount...maxCount)).map { _ in newElement() }
    }
    
}
