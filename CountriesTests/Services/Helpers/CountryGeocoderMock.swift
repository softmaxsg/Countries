//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
import CoreLocation
@testable import Countries

final class CountryGeocoderMock: CountryGeocoderProtocol {

    typealias CountryAtLocationImpl = (CLLocation, @escaping CountryGeocoderCompletionHandler) -> Void
    
    private let countryAtLocationImpl: CountryAtLocationImpl
    
    init(countryAtLocation countryAtLocationImpl: @escaping CountryAtLocationImpl) {
        self.countryAtLocationImpl = countryAtLocationImpl
    }
    
    func country(at location: CLLocation, completion handler: @escaping CountryGeocoderCompletionHandler) {
        countryAtLocationImpl(location, handler)
    }
    
}
