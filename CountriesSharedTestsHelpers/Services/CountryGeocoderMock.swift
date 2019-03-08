//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
import CoreLocation
import CountriesShared

public final class CountryGeocoderMock: CountryGeocoderProtocol {

    public typealias CountryAtLocationImpl = (CLLocation, @escaping CountryGeocoderCompletionHandler) -> Void
    
    private let countryAtLocationImpl: CountryAtLocationImpl
    
    public init(countryAtLocation countryAtLocationImpl: @escaping CountryAtLocationImpl) {
        self.countryAtLocationImpl = countryAtLocationImpl
    }
    
    public func country(at location: CLLocation, completion handler: @escaping CountryGeocoderCompletionHandler) {
        countryAtLocationImpl(location, handler)
    }
    
}
