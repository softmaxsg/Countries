//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import UIKit

final class CountryDetailsView: UIView {

    private(set) var briefCountryView: CountryBriefDetailsView?
    
    @IBOutlet weak var briefDetailsWrapper: UIStackView?
    @IBOutlet weak var advancedDetailsWrapper: UIStackView?

    @IBOutlet weak var capitalLabel: UILabel?
    @IBOutlet weak var capitalWrapper: UIView?

    @IBOutlet weak var regionLabel: UILabel?
    @IBOutlet weak var regionWrapper: UIView?

    @IBOutlet weak var regionalBlocsLabel: UILabel?
    @IBOutlet weak var regionalBlocsWrapper: UIView?

    @IBOutlet weak var languagesLabel: UILabel?
    @IBOutlet weak var languagesWrapper: UIView?

    @IBOutlet weak var currenciesLabel: UILabel?
    @IBOutlet weak var currenciesWrapper: UIView?

    var isAdvancedDetailsVisible: Bool {
        get { return !(advancedDetailsWrapper?.isHidden ?? false) }
        set { advancedDetailsWrapper?.isHidden = !newValue }
    }
    
    func configure(with details: CountryDetailsViewModelProtocol) {
        briefCountryView?.configure(with: details)

        setText(details.capital, to: capitalLabel, in: capitalWrapper)
        setText(details.region, to: regionLabel, in: regionWrapper)
        setText(details.regionalBlocs, to: regionalBlocsLabel, in: regionalBlocsWrapper)
        setText(details.languages, to: languagesLabel, in: languagesWrapper)
        setText(details.currencies, to: currenciesLabel, in: currenciesWrapper)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        briefCountryView = CountryBriefDetailsView.load()
        if let briefCountryView = briefCountryView {
            briefDetailsWrapper?.insertArrangedSubview(briefCountryView, at: 0)
        }
    }
    
}

extension CountryDetailsView {
    
    private func setText(_ text: String, to label: UILabel?, in wrapper: UIView?) {
        label?.text = text
        wrapper?.isHidden = text.isEmpty
    }
    
}
