//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import XCTest
@testable import Countries

class CountryDetailsViewTestCase: XCTestCase {
    
    let defaultWidth: CGFloat = 350
    
    let countryCode = "AA"
    let countryName = "Country Name"
    let countryNativeName = "Country Native Name"
    let countryCapital = "Capital Name"
    let countryLanguages = [Language.random(name: "Language Name", nativeName: "Language Native Name")]
    let countryCurrencies = [Currency.random(code: "CODE", name: "Currency Name", symbol: "Symbol")]
    let countryRegion = "Region Name"
    let countryRegionalBlocs = [RegionalBloc.random(acronym: "ACRONYM", name: "Regional Bloc Name")]
    let countryPopulation = UInt64(7_654_321)
    let countryAreaSize = 123_456.0

    private(set) lazy var expectedImageURL = URL(string: "https://flagpedia.net/data/flags/small/\(countryCode.lowercased()).png")!
    let expectedImage = UIImage.image(size: CGSize(width: 133, height: 80), color: .cyan)
    
    lazy var imageLoaderMock = ImageLoaderMock { url, _, completion in
        completion(url, url == self.expectedImageURL ? self.expectedImage : nil)
        return EmptyTask()
    }
    
}

extension CountryDetailsViewTestCase {
    
    func adjustSize(for view: UIView) {
        let height = view.systemLayoutSizeFitting(
            CGSize(width: defaultWidth, height: 0),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
            ).height
        
        view.frame = CGRect(x: 0, y: 0, width: defaultWidth, height: height)
    }
    
}
