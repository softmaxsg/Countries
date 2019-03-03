//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
import CoreLocation

typealias CountryCode = String
typealias CountryGeocoderCompletionHandler = (Result<CountryCode>) -> Void

protocol CountryGeocoderProtocol {

    func country(at location: CLLocation, completion handler: @escaping CountryGeocoderCompletionHandler)
    
}

final class CountryGeocoder: CountryGeocoderProtocol {

    enum Error: Swift.Error { case unknown }
    
    private let geocoder: CLGeocoderProtocol
    
    init(geocoder: CLGeocoderProtocol = CLGeocoder()) {
        self.geocoder = geocoder
    }
    
    func country(at location: CLLocation, completion handler: @escaping CountryGeocoderCompletionHandler) {
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first, let countryCode = placemark.isoCountryCode else {
                handler(.failure(error ?? Error.unknown))
                return
            }
            
            handler(.success(countryCode))
        }
    }
    
}
