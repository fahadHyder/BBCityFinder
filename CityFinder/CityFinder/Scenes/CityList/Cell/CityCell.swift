//
//  CityCell.swift
//  CityFinder
//
//  Created by fahad c h on 14/11/19.
//  Copyright © 2019 backbase. All rights reserved.
//

import UIKit

class CityCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.isAccessibilityElement = true
        titleLabel.accessibilityTraits = .staticText
        subTitleLabel.isAccessibilityElement = true
        subTitleLabel.accessibilityTraits = .staticText
        titleLabel.accessibilityIdentifier = "automationCityCellTitleLabel"
        subTitleLabel.accessibilityIdentifier = "automationCityCellSubTitleLabel"
    }
    
    func configure(title: String, subTitle: String) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
    }
}
