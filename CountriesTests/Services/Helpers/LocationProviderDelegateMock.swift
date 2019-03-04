//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
import CoreLocation
@testable import Countries

final class LocationProviderDelegateMock: LocationProviderDelegate {
    
    typealias DidUpdateLocationImpl = (LocationProviderProtocol, Location) -> Void
    typealias DidFailWithErrorImpl = (LocationProviderProtocol, Error) -> Void

    private let didUpdateLocationImpl: DidUpdateLocationImpl
    private let didFailWithErrorImpl: DidFailWithErrorImpl
    
    init(didUpdateLocation didUpdateLocationImpl: @escaping DidUpdateLocationImpl,
         didFailWithError didFailWithErrorImpl: @escaping DidFailWithErrorImpl) {
        self.didUpdateLocationImpl = didUpdateLocationImpl
        self.didFailWithErrorImpl = didFailWithErrorImpl
    }
    
    func locationProvider(_ provider: LocationProviderProtocol, didUpdateLocation location: Location) {
        didUpdateLocationImpl(provider, location)
    }
    
    func locationProvider(_ provider: LocationProviderProtocol, didFailWithError error: Error) {
        didFailWithErrorImpl(provider, error)
    }

}
