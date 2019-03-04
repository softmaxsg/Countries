//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import XCTest
@testable import Countries

final class CountryViewCellTests: XCTestCase {
    
    private let defaultWidth: CGFloat = 350
    
    private let expectedImageURL = URL(string: "https://flagpedia.net/data/flags/small/aa.png")!
    private let expectedImage = UIImage.image(size: CGSize(width: 133, height: 80), color: .cyan)
    
    private lazy var imageLoaderMock = ImageLoaderMock { url, _, completion in
        completion(url, url == self.expectedImageURL ? self.expectedImage : nil)
        return EmptyTask()
    }
    
    private lazy var cell: CountryViewCell = {
        let cell = CountryViewCell()
        cell.briefCountryView?.imageLoader = imageLoaderMock
        return cell
    }()
    
    func testNormalAppearance() {
        let cell = self.cell
        cell.configure(with: CountryListItemViewModel(country: .random(
            countryCode2: "AA",
            name: "Country Name",
            nativeName: "Country Native Name",
            population: 7_654_321,
            areaSize: 123_456
        )))
        
        adjustSize(for: cell)
        snapshotVerifyView(cell)
    }
    
    func testNoAreaSizeAppearance() {
        let cell = self.cell
        cell.configure(with: CountryListItemViewModel(country: .random(
            countryCode2: "AA",
            name: "Country Name",
            nativeName: "Country Native Name",
            population: 7_654_321,
            areaSize: nil
        )))
        
        adjustSize(for: cell)
        snapshotVerifyView(cell)
    }

}

extension CountryViewCellTests {
    
    func adjustSize(for view: UIView) {
        let height = view.systemLayoutSizeFitting(
            CGSize(width: defaultWidth, height: 0),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
            ).height
        
        cell.frame = CGRect(x: 0, y: 0, width: defaultWidth, height: height)
    }
    
}
