//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

extension RangeReplaceableCollection {
    
    public mutating func randomlyInsert(_ array: Self) {
        let index = self.index(startIndex, offsetBy: Int.random(in: 0..<count))
        insert(contentsOf: array, at: index)
    }
    
    public mutating func randomlyInsertElements(_ array: Self) {
        let indices = array
            .map { _ in index(startIndex, offsetBy: Int.random(in: 0..<count)) }
            .sorted()

        zip(array, indices).reversed().forEach { element, index in
            insert(element, at: index)
        }
    }

    public func randomlyInserted(_ array: Self) -> Self {
        var result = self
        result.randomlyInsert(array)
        return result
    }

    public func randomlyInsertedElements(_ array: Self) -> Self {
        var result = self
        result.randomlyInsertElements(array)
        return result
    }

}
