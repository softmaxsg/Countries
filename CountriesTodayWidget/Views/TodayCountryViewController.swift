//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayCountryViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var countryDetailsWrapper: UIStackView?
    @IBOutlet weak var emptyView: UIView?

    private let countryDetailsView: CountryDetailsView? = .load()
    private let countryStorageService = CountryStorageService()

    private let assembly = TodayCountryAssembly()
    private lazy var viewModel = assembly.todayCountryViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded

        if let countryDetailsView = countryDetailsView {
            countryDetailsWrapper?.addArrangedSubview(countryDetailsView)
            updateControls()
        }
    }

    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        countryDetailsView?.isAdvancedDetailsVisible = activeDisplayMode == .expanded
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        viewModel.updateCountry { [weak self] result in
            OperationQueue.main.addOperation {
                self?.updateControls()
                completionHandler(NCUpdateResult(result))
            }
        }}
       
    
}

extension TodayCountryViewController {
    
    private func updateControls() {
        if let countryDetails = viewModel.details {
            countryDetailsView?.configure(with: countryDetails)
            countryDetailsView?.isHidden = false
            emptyView?.isHidden = true
        } else {
            countryDetailsView?.isHidden = true
            emptyView?.isHidden = false
        }
    }
    
}

extension NCUpdateResult {
    
    init(_ result: UpdateResult) {
        switch result {
        case .new: self = .newData
        case .same: self = .noData
        case .error: self = .failed
        }
    }
    
}
