//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
import CoreLocation

typealias LocationProviderCompletionHandler = (Result<Location>) -> Void

protocol LocationProviderDelegate: class {

    func locationProvider(_ provider: LocationProviderProtocol, didUpdateLocation location: Location)
    func locationProvider(_ provider: LocationProviderProtocol, didFailWithError error: Error)

}

protocol LocationProviderProtocol {

    func startMonitoring(delegate: LocationProviderDelegate)
    func stopMonitoring()

}

final class LocationProvider: NSObject, LocationProviderProtocol {

    private let locationManager: CLLocationManagerProtocol
    private let countryGeocoder: CountryGeocoderProtocol
    
    private var lastAuthorizationStatus = CLAuthorizationStatus.notDetermined
    
    // It makes sense to stop monitoring location change in case delegate is deallocated
    private weak var delegate: LocationProviderDelegate? {
        didSet {
            if delegate == nil { internalStopMonitoring() }
        }
    }

    @available(*, unavailable)
    override init () { fatalError() }
    
    init(locationManager: CLLocationManagerProtocol = CLLocationManager(),
         countryGeocoder: CountryGeocoderProtocol = CountryGeocoder()) {
        self.locationManager = locationManager
        self.countryGeocoder = countryGeocoder
        super.init()
    }
    
    deinit {
        stopMonitoring()
    }
    
    func startMonitoring(delegate: LocationProviderDelegate) {
        // Restarting monitoring is required in order to force obtaining the current location
        if self.delegate != nil {
            internalStopMonitoring()
        }
        
        self.delegate = delegate
        
        // Storing lastAuthorizationStatus is required since locationManager(_:didChangeAuthorization:) can be called without an actual status change
        lastAuthorizationStatus = locationManager.authorizationStatus()
        if lastAuthorizationStatus == .notDetermined {
            requestAuthorization()
        } else {
            internalStartMonitoring()
        }
    }
    
    func stopMonitoring() {
        guard delegate != nil else { return }
        self.delegate = nil
    }

}

extension LocationProvider {
    
    private func requestAuthorization() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func internalStartMonitoring() {
        locationManager.delegate = self
        locationManager.startMonitoringSignificantLocationChanges()
    }

    private func internalStopMonitoring() {
        locationManager.delegate = nil
        locationManager.stopMonitoringSignificantLocationChanges()
    }

}

extension LocationProvider: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard lastAuthorizationStatus != status else { return }
        lastAuthorizationStatus = status
        
        switch status {
        case .notDetermined:
            return
        case .authorizedAlways:
            fallthrough
        case .authorizedWhenInUse:
            internalStartMonitoring()
        default:
            delegate?.locationProvider(self, didFailWithError: CLError(CLError.denied))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        countryGeocoder.country(at: location) { result in
            let locationDetails = Location(
                coordinate: Coordinate(location.coordinate),
                countryCode: result.value
            )
            
            self.delegate?.locationProvider(self, didUpdateLocation: locationDetails)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let locationError = error as? CLError {
            switch locationError.code {
            case CLError.locationUnknown: return
            case CLError.denied: stopMonitoring()
            default: break
            }
        }

        delegate?.locationProvider(self, didFailWithError: error)
    }
}
