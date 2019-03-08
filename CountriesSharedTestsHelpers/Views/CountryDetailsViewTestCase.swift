//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import XCTest
import CountriesShared

open class CountryDetailsViewTestCase: XCTestCase {
    
    public let defaultWidth: CGFloat = 350
    
    public let countryCode = "AA"
    public let countryName = "Country Name"
    public let countryNativeName = "Country Native Name"
    public let countryCapital = "Capital Name"
    public let countryLanguages = [Language.random(name: "Language Name", nativeName: "Language Native Name")]
    public let countryCurrencies = [Currency.random(code: "CODE", name: "Currency Name", symbol: "Symbol")]
    public let countryRegion = "Region Name"
    public let countryRegionalBlocs = [RegionalBloc.random(acronym: "ACRONYM", name: "Regional Bloc Name")]
    public let countryPopulation = UInt64(7_654_321)
    public let countryAreaSize = 123_456.0

    private(set) public lazy var expectedImageURL = URL(string: "https://flagpedia.net/data/flags/small/\(countryCode.lowercased()).png")!
    public let expectedImage = UIImage.image(size: CGSize(width: 133, height: 80), color: .cyan)
    
    public lazy var imageLoaderMock = ImageLoaderMock { url, _, completion in
        completion(url, url == self.expectedImageURL ? self.expectedImage : nil)
        return EmptyTask()
    }
    
}

extension CountryDetailsViewTestCase {
    
    public func adjustSize(for view: UIView) {
        let height = view.systemLayoutSizeFitting(
            CGSize(width: defaultWidth, height: 0),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
            ).height
        
        view.frame = CGRect(x: 0, y: 0, width: defaultWidth, height: height)
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
}
