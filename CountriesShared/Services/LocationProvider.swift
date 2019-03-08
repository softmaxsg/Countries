//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
import CoreLocation

public typealias LocationProviderCompletionHandler = (Result<Location>) -> Void

public protocol LocationProviderProtocol {

    func requestLocation(completion handler: @escaping LocationProviderCompletionHandler)

}

public final class LocationProvider: NSObject, LocationProviderProtocol {
    
    public enum Error: Swift.Error {
        
        case simultaneousRequestsAreNotSupported
        
    }

    private let locationManager: CLLocationManagerProtocol
    private let countryGeocoder: CountryGeocoderProtocol
    
    private var lastAuthorizationStatus = CLAuthorizationStatus.notDetermined
    private var completionHanlder: LocationProviderCompletionHandler? = nil

    @available(*, unavailable)
    override init () { fatalError() }
    
    public init(locationManager: CLLocationManagerProtocol = CLLocationManager(),
                countryGeocoder: CountryGeocoderProtocol = CountryGeocoder()) {
        self.locationManager = locationManager
        self.countryGeocoder = countryGeocoder
        super.init()
    }

    public func requestLocation(completion handler: @escaping LocationProviderCompletionHandler) {
        guard completionHanlder == nil else {
            handler(.failure(Error.simultaneousRequestsAreNotSupported))
            return
        }

        completionHanlder = handler
        
        // Storing lastAuthorizationStatus is required since locationManager(_:didChangeAuthorization:) can be called without an actual status change
        lastAuthorizationStatus = locationManager.authorizationStatus()
        switch lastAuthorizationStatus {
        case .notDetermined:
            requestAuthorization()
        case .restricted:
            fallthrough
        case .denied:
            requestDidFail(with: CLError(CLError.denied))
        default:
            requestLocation()
        }
    }

}

extension LocationProvider {
    
    private func requestAuthorization() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func requestLocation() {
        locationManager.delegate = self
        locationManager.requestLocation()
    }
    
}

extension LocationProvider: CLLocationManagerDelegate {

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard lastAuthorizationStatus != status else { return }
        lastAuthorizationStatus = status
        
        switch status {
        case .notDetermined:
            return
        case .authorizedAlways:
            fallthrough
        case .authorizedWhenInUse:
            requestLocation()
        default:
            requestDidFail(with: CLError(CLError.denied))
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        countryGeocoder.country(at: location) { result in
            let locationDetails = Location(
                coordinate: Coordinate(location.coordinate),
                countryCode: result.value
            )
            
            self.requestDidSucceed(with: locationDetails)
        }
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Swift.Error) {
        requestDidFail(with: error)
    }
}

extension LocationProvider {
    
    private func requestDidSucceed(with location: Location) {
        completionHanlder?(.success(location))
        completionHanlder = nil
    }
    
    private func requestDidFail(with error: Swift.Error) {
        completionHanlder?(.failure(error))
        completionHanlder = nil
    }

}
