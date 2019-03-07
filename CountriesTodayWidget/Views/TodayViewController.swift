//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var countryDetailsWrapper: UIStackView?
    
    private let countryDetailsView: CountryDetailsView? = .load()
    private let countryStorageService = CountryStorageService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
        if let currentCountry = countryStorageService.loadCountry(), let countryDetailsView = countryDetailsView {
            let countryViewModel = CountryDetailsViewModel(country: currentCountry)
            countryDetailsView.configure(with: countryViewModel)
            countryDetailsWrapper?.addArrangedSubview(countryDetailsView)
        }
    }

    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        countryDetailsView?.isAdvancedDetailsVisible = activeDisplayMode == .expanded
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
}
