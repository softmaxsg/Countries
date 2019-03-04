//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Countries

final class FilteringServiceMock: FilteringServiceProtocol {
    
    typealias FilteredImpl = ([Country], String) -> [Country]
    
    private let filteredImpl: FilteredImpl
    
    init(filtered filteredImpl: @escaping FilteredImpl) {
        self.filteredImpl = filteredImpl
    }
    
    func filtered(_ countries: [Country], using text: String) -> [Country] {
        return filteredImpl(countries, text)
    }
    
}

extension FilteringServiceMock {
    
    static var empty: FilteringServiceMock {
        return FilteringServiceMock { countries, _ in countries }
    }
    
}
