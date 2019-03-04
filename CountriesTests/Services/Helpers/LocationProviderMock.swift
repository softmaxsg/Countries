//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Countries

final class LocationProviderMock: LocationProviderProtocol {
    
    typealias StartMonitoringImpl = (LocationProviderDelegate) -> Void
    typealias StopMonitoringImpl = () -> Void
    
    private let startMonitoringImpl: StartMonitoringImpl
    private let stopMonitoringImpl: StopMonitoringImpl
    
    init(startMonitoring startMonitoringImpl: @escaping StartMonitoringImpl,
         stopMonitoring stopMonitoringImpl: @escaping StopMonitoringImpl) {
        self.startMonitoringImpl = startMonitoringImpl
        self.stopMonitoringImpl = stopMonitoringImpl
    }
    
    func startMonitoring(delegate: LocationProviderDelegate) {
        startMonitoringImpl(delegate)
    }
    
    func stopMonitoring() {
        stopMonitoringImpl()
    }

}
