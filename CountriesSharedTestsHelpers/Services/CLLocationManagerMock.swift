//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
import CoreLocation
import CountriesShared

public final class CLLocationManagerMock: CLLocationManagerProtocol {
    
    public typealias AuthorizationStatusImpl = () -> CLAuthorizationStatus
    public typealias MethodImpl = () -> Void
    
    private let authorizationStatusImpl: AuthorizationStatusImpl
    private let requestWhenInUseAuthorizationImpl: MethodImpl
    private let requestLocationImpl: MethodImpl

    public init(authorizationStatus authorizationStatusImpl: @escaping AuthorizationStatusImpl,
                requestWhenInUseAuthorization requestWhenInUseAuthorizationImpl: @escaping MethodImpl,
                requestLocation requestLocationImpl: @escaping MethodImpl) {
        self.authorizationStatusImpl = authorizationStatusImpl
        self.requestWhenInUseAuthorizationImpl = requestWhenInUseAuthorizationImpl
        self.requestLocationImpl = requestLocationImpl
    }
    
    // Required for delegate methods
    private let dummyLocationManager = CLLocationManager()
    public var delegate: CLLocationManagerDelegate?
    
    public func authorizationStatus() -> CLAuthorizationStatus {
        return authorizationStatusImpl()
    }
    
    public func requestWhenInUseAuthorization() {
        requestWhenInUseAuthorizationImpl()
    }
    
    public func requestLocation() {
        requestLocationImpl()
    }

}

extension CLLocationManagerMock {
    
    public func notifyDidChangeAuthorization(_ status: CLAuthorizationStatus) {
        delegate?.locationManager?(dummyLocationManager, didChangeAuthorization: status)
    }
    
    public func notifyDidUpdateLocations(_ locations: [CLLocation]) {
        delegate?.locationManager?(dummyLocationManager, didUpdateLocations: locations)
    }
    
    public func notifyDidFailWithError(_ error: Error) {
        delegate?.locationManager?(dummyLocationManager, didFailWithError: error)
    }
    
}
