//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import XCTest
@testable import Countries

extension XCTestCase {

    func view<T>(nibName: String, size: CGSize? = nil) -> T where T: UIView {
        let bundle = Bundle(for: T.self)
        let view = T.load(nibName: nibName, bundle: bundle) as! T
        
        if let size = size {
            let bounds = CGRect(origin: .zero, size: size)
            view.frame = bounds
        }
        
        return view
    }

}
