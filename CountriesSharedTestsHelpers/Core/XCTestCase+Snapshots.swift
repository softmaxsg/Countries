//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import XCTest

extension XCTest {
    
    public func snapshotVerifyView(_ view: UIView, file: StaticString = #file, line: UInt = #line) {
        let bundle = Bundle(for: type(of: self))
        let referenceImageName = "\(normalizedName)@\(Int((view.window?.screen ?? UIScreen.main).scale))x"

        guard let expectedDataURL = bundle.url(forResource: referenceImageName, withExtension: "png"),
            let expectedData = try? Data(contentsOf: expectedDataURL) else {
            XCTFail("Reference image does not exist", file: file, line: line)
            return
        }
        
        let snapshotData = view.snapshotData()
        XCTAssertEqual(snapshotData, expectedData, "Existing view snapshot does not match the reference image", file: file, line: line)
    }
    
}

extension XCTest {

    private class BundleIdentifier { }

    private var normalizedName: String {
        let name = self.name
        let regex = try! NSRegularExpression(pattern: "^-\\[([\\w\\d]+)\\s([\\w\\d]+)\\]$", options: .caseInsensitive)
        guard let match = regex.firstMatch(in: name, range: NSRange(name.startIndex..., in: name)),
            match.numberOfRanges == 3,
            let classRange = Range(match.range(at: 1), in: name),
            let methodRange = Range(match.range(at: 2), in: name) else {
            // Should not really happen but in case
            return name
        }

        return "\(name[classRange])_\(name[methodRange])"
    }
}

extension UIView {
    
    fileprivate func snapshotData() -> Data {
        return imagePresentation().pngData() ?? Data()
    }
    
    private func imagePresentation() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, (window?.screen ?? UIScreen.main).scale)
        defer { UIGraphicsEndImageContext() }
        
        if let context = UIGraphicsGetCurrentContext() {
            layer.render(in: context)
        }
        
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
    
}
