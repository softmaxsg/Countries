//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
import CountriesShared

public final class LocationProviderMock: LocationProviderProtocol {
    
    public typealias RequestLocationImpl = (LocationProviderCompletionHandler) -> Void
    
    private let requestLocationImpl: RequestLocationImpl
    
    public init(requestLocation requestLocationImpl: @escaping RequestLocationImpl) {
        self.requestLocationImpl = requestLocationImpl
    }
    
    public func requestLocation(completion handler: @escaping LocationProviderCompletionHandler) {
        requestLocationImpl(handler)
    }

}

extension LocationProviderMock {
    
    public static var empty: LocationProviderMock {
        return LocationProviderMock { _ in }
    }
    
}
