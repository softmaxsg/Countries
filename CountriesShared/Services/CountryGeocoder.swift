//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
import CoreLocation

public typealias CountryCode = String
public typealias CountryGeocoderCompletionHandler = (Result<CountryCode>) -> Void

public protocol CountryGeocoderProtocol {

    func country(at location: CLLocation, completion handler: @escaping CountryGeocoderCompletionHandler)
    
}

public final class CountryGeocoder: CountryGeocoderProtocol {

    public enum Error: Swift.Error { case unknown }
    
    private let geocoder: CLGeocoderProtocol
    
    public init(geocoder: CLGeocoderProtocol = CLGeocoder()) {
        self.geocoder = geocoder
    }
    
    public func country(at location: CLLocation, completion handler: @escaping CountryGeocoderCompletionHandler) {
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first, let countryCode = placemark.isoCountryCode else {
                handler(.failure(error ?? Error.unknown))
                return
            }
            
            handler(.success(countryCode))
        }
    }
    
}
