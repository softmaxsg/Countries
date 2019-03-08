//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
import CountriesShared
@testable import Countries

final class SortingServiceMock: SortingServiceProtocol {
    
    typealias SortedImpl = ([Country], Coordinate) -> [Country]
    
    private let sortedImpl: SortedImpl
    
    init(sorted sortedImpl: @escaping SortedImpl) {
        self.sortedImpl = sortedImpl
    }
    
    func sorted(_ countries: [Country], coordinate: Coordinate) -> [Country] {
        return sortedImpl(countries, coordinate)
    }
    
}

extension SortingServiceMock {
    
    static var empty: SortingServiceMock {
        return SortingServiceMock { restaurants, _ in restaurants }
    }
    
}
