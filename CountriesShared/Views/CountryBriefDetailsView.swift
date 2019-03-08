//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import UIKit

public final class CountryBriefDetailsView: UIView, ImageContainerView {
    
    private lazy var placeholderImage = UIImage(named: "FlagPlaceholder", in: Bundle(for: CountryBriefDetailsView.self), compatibleWith: nil)!
    
    @IBOutlet weak var countryFlagImage: UIImageView?
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var populationLabel: UILabel?
    @IBOutlet weak var areaSizeLabel: UILabel?
    @IBOutlet weak var areaSizeWrapper: UIView?
    
    public var imageLoader: ImageLoaderProtocol = DependencyContainer.shared.imageLoader
    public var currentImageLoaderTask: Cancellable?
    
    // ImageContainerView works with `imageView` property
    public var imageView: UIImageView? { return countryFlagImage }
    
    public func configure(with details: CountryBriefDetailsViewModelProtocol) {
        nameLabel?.text = details.name
        populationLabel?.text = details.population
        areaSizeLabel?.text = details.areaSize
        areaSizeWrapper?.isHidden = details.areaSize.isEmpty
        
        displayImage(with: details.flagUrl, placeholder: placeholderImage)
    }
    
}
