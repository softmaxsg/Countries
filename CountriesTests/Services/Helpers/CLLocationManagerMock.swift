//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
import CoreLocation
@testable import Countries

final class CLLocationManagerMock: CLLocationManagerProtocol {
    
    typealias AuthorizationStatusImpl = () -> CLAuthorizationStatus
    typealias MethodImpl = () -> Void
    
    private let authorizationStatusImpl: AuthorizationStatusImpl
    private let requestWhenInUseAuthorizationImpl: MethodImpl
    private let requestLocationImpl: MethodImpl

    init(authorizationStatus authorizationStatusImpl: @escaping AuthorizationStatusImpl,
         requestWhenInUseAuthorization requestWhenInUseAuthorizationImpl: @escaping MethodImpl,
         requestLocation requestLocationImpl: @escaping MethodImpl) {
        self.authorizationStatusImpl = authorizationStatusImpl
        self.requestWhenInUseAuthorizationImpl = requestWhenInUseAuthorizationImpl
        self.requestLocationImpl = requestLocationImpl
    }
    
    // Required for delegate methods
    private let dummyLocationManager = CLLocationManager()
    var delegate: CLLocationManagerDelegate?
    
    func authorizationStatus() -> CLAuthorizationStatus {
        return authorizationStatusImpl()
    }
    
    func requestWhenInUseAuthorization() {
        requestWhenInUseAuthorizationImpl()
    }
    
    func requestLocation() {
        requestLocationImpl()
    }

}

extension CLLocationManagerMock {
    
    func notifyDidChangeAuthorization(_ status: CLAuthorizationStatus) {
        delegate?.locationManager?(dummyLocationManager, didChangeAuthorization: status)
    }
    
    func notifyDidUpdateLocations(_ locations: [CLLocation]) {
        delegate?.locationManager?(dummyLocationManager, didUpdateLocations: locations)
    }
    
    func notifyDidFailWithError(_ error: Error) {
        delegate?.locationManager?(dummyLocationManager, didFailWithError: error)
    }
    
}
