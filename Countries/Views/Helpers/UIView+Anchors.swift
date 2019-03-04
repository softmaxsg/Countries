//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import UIKit

extension UIView {
    
    func edges(equalTo view: UIView, insets: UIEdgeInsets) {
        translatesAutoresizingMaskIntoConstraints = false

        topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top).isActive=true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom).isActive=true
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left).isActive=true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets.right).isActive=true
    }
    
}
