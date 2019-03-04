//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import UIKit

final class CountryViewCell: UITableViewCell {
    
    let briefCountryView: CountryBriefView?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        briefCountryView = CountryBriefView.load(
            nibName: "CountryBriefView",
            bundle: Bundle(for: CountryBriefView.self)
        )
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        if let briefCountryView = briefCountryView {
            contentView.addSubview(briefCountryView)
            briefCountryView.edges(equalTo: contentView, insets: UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16))
        } else {
            assertionFailure()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: CountryListItemViewModelProtocol) {
        briefCountryView?.configure(with: viewModel)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        briefCountryView?.cancelImageLoading()
    }
    
}

extension CountryViewCell {
    
    class func register(in tableView: UITableView, with identifier: String) {
        tableView.register(CountryViewCell.self, forCellReuseIdentifier: identifier)
    }
    
}
