//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
import CoreLocation
import CountriesShared

public final class CLGeocoderMock: CLGeocoderProtocol {
    
    public typealias ReverseGeocodeLocationImpl = (CLLocation, @escaping CLGeocodeCompletionHandler) -> Void
    
    private let reverseGeocodeLocationImpl: ReverseGeocodeLocationImpl
    
    public init(reverseGeocodeLocation reverseGeocodeLocationImpl: @escaping ReverseGeocodeLocationImpl) {
        self.reverseGeocodeLocationImpl = reverseGeocodeLocationImpl
    }
    
    public func reverseGeocodeLocation(_ location: CLLocation, completionHandler: @escaping CLGeocodeCompletionHandler) {
        reverseGeocodeLocationImpl(location, completionHandler)
    }

}
