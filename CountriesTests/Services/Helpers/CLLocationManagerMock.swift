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
    private let startMonitoringSignificantLocationChangesImpl: MethodImpl
    private let stopMonitoringSignificantLocationChangesImpl: MethodImpl

    init(authorizationStatus authorizationStatusImpl: @escaping AuthorizationStatusImpl,
         requestWhenInUseAuthorization requestWhenInUseAuthorizationImpl: @escaping MethodImpl,
         startMonitoringSignificantLocationChanges startMonitoringSignificantLocationChangesImpl: @escaping MethodImpl,
         stopMonitoringSignificantLocationChanges stopMonitoringSignificantLocationChangesImpl: @escaping MethodImpl) {
        self.authorizationStatusImpl = authorizationStatusImpl
        self.requestWhenInUseAuthorizationImpl = requestWhenInUseAuthorizationImpl
        self.startMonitoringSignificantLocationChangesImpl = startMonitoringSignificantLocationChangesImpl
        self.stopMonitoringSignificantLocationChangesImpl = stopMonitoringSignificantLocationChangesImpl
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
    
    func startMonitoringSignificantLocationChanges() {
        startMonitoringSignificantLocationChangesImpl()
    }
    
    func stopMonitoringSignificantLocationChanges() {
        stopMonitoringSignificantLocationChangesImpl()
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
