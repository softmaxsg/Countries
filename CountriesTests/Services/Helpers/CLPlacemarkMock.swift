//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
import CoreLocation

final class CLPlacemarkMock: CLPlacemark {
    
    private let _location: CLLocation?
    private let _isoCountryCode: String?
    
    override var location: CLLocation? {
        return _location
    }
    
    override var isoCountryCode: String? {
        return _isoCountryCode
    }
    
    init(location: CLLocation?, isoCountryCode: String?) {
        _location = location
        _isoCountryCode = isoCountryCode
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
