//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
import CoreLocation

// Class requirement is for allowing to update `delegate` property for constant instances of `CLLocationManagerProtocol`
public protocol CLLocationManagerProtocol: class {

    var delegate: CLLocationManagerDelegate? { get set }

    func authorizationStatus() -> CLAuthorizationStatus
    func requestWhenInUseAuthorization()
    
    func requestLocation()
    
}

extension CLLocationManager: CLLocationManagerProtocol {
    
    public func authorizationStatus() -> CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
}
