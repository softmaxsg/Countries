//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
import CoreLocation

public protocol CLGeocoderProtocol {
    
    func reverseGeocodeLocation(_ location: CLLocation, completionHandler: @escaping CLGeocodeCompletionHandler)
    
}

extension CLGeocoder: CLGeocoderProtocol { }
