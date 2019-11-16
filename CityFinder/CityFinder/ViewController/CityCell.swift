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
    
    func configure(title: String, subTitle: String) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
    }
}
