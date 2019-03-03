//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
import CoreLocation
@testable import Countries

final class CLGeocoderMock: CLGeocoderProtocol {
    
    typealias ReverseGeocodeLocationImpl = (CLLocation, @escaping CLGeocodeCompletionHandler) -> Void
    
    private let reverseGeocodeLocationImpl: ReverseGeocodeLocationImpl
    
    init(reverseGeocodeLocation reverseGeocodeLocationImpl: @escaping ReverseGeocodeLocationImpl) {
        self.reverseGeocodeLocationImpl = reverseGeocodeLocationImpl
    }
    
    func reverseGeocodeLocation(_ location: CLLocation, completionHandler: @escaping CLGeocodeCompletionHandler) {
        reverseGeocodeLocationImpl(location, completionHandler)
    }

}
