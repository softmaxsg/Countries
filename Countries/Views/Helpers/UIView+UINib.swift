//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import UIKit

extension UIView {
    
    class func load<T>(nibName: String, bundle: Bundle? = nil) -> T? where T: UIView {
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: nil).compactMap({ $0 as? T }).first
    }

}
