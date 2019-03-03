//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
import CoreLocation

protocol CLGeocoderProtocol {
    
    func reverseGeocodeLocation(_ location: CLLocation, completionHandler: @escaping CLGeocodeCompletionHandler)
    
}

extension CLGeocoder: CLGeocoderProtocol { }
