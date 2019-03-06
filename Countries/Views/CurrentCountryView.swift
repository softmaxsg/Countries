//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import UIKit

final class CurrentCountryView: UIView {
    
    private(set) var detailsView: CountryDetailsView?
    
    @IBOutlet weak var detailsWrapper: UIStackView?
    @IBOutlet weak var toggleViewModeButton: UIButton?

    private var viewModel: CurrentCountryViewModelProtocol?
    
    func configure(with viewModel: CurrentCountryViewModelProtocol) {
        self.viewModel = viewModel
        
        detailsView?.configure(with: viewModel)
        updateView(animated: false)
    }
    
    @IBAction func toggleViewModeTapped() {
        guard let viewModel = viewModel else { return }
        switch viewModel.viewMode {
        case .compact: viewModel.viewMode = .expanded
        case .expanded: viewModel.viewMode = .compact
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        detailsView = CountryDetailsView.load()
        if let detailsView = detailsView {
            detailsWrapper?.addArrangedSubview(detailsView)
        }
    }
    
}

extension CurrentCountryView: CurrentCountryViewModelDelegate {

    func viewModeDidChange() {
        updateView(animated: true)
    }
    
}

extension CurrentCountryView {

    private func updateView(animated: Bool) {
        func update() {
            self.detailsView?.isAdvancedDetailsVisible = self.viewModel?.viewMode.isExpanded ?? false
        }
        
        if animated {
            UIView.animate(withDuration: 0.25, animations: update)
        } else {
            update()
        }

        updateToggleButton()
    }
    
    private func updateToggleButton() {
        let buttonTitle = viewModel?.viewMode.isExpanded ?? false ? "Less" : "More"
        toggleViewModeButton?.setTitle(buttonTitle, for: .normal)
    }
    
}

private extension CurrentCountryViewMode {
    
    var isExpanded: Bool {
        return self == .expanded
    }
    
}
