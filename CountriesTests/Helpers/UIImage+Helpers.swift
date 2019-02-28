//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import UIKit

extension UIImage {

    class func image(size: CGSize, scale: CGFloat = UIScreen.main.scale, color: UIColor? = nil) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.image { context in
            if let color = color {
                color.setFill()
                context.fill(CGRect(origin: .zero, size: size))
            }
        }
    }

}
