//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

// Simple light version dependency container for shared dependencies
final class DependencyContainer {
    
    static let shared = DependencyContainer()
    
    let imageLoader = ImageLoader()
    
}
