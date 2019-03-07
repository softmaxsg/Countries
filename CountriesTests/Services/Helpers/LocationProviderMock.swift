//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Countries

final class LocationProviderMock: LocationProviderProtocol {
    
    typealias RequestLocationImpl = (LocationProviderCompletionHandler) -> Void
    
    private let requestLocationImpl: RequestLocationImpl
    
    init(requestLocation requestLocationImpl: @escaping RequestLocationImpl) {
        self.requestLocationImpl = requestLocationImpl
    }
    
    func requestLocation(completion handler: @escaping LocationProviderCompletionHandler) {
        requestLocationImpl(handler)
    }

}
