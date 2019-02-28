//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import UIKit
@testable import Countries

final class ImageLoaderMock: ImageLoaderProtocol {
    
    typealias LoadImageImpl = (URL, @escaping LoadingHandler, @escaping CompletionHandler) -> Cancellable
    
    private let loadImageImpl: LoadImageImpl
    
    init(loadImage loadImageImpl: @escaping LoadImageImpl) {
        self.loadImageImpl = loadImageImpl
    }
    
    func image(with url: URL, loadingHandler: @escaping LoadingHandler, completionHandler: @escaping CompletionHandler) -> Cancellable {
        return loadImageImpl(url, loadingHandler, completionHandler)
    }
    
}
