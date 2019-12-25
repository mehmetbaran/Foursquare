//
//  TipsTableViewCell.swift
//  Foursquare
//
//  Created by Mehmet Baran on 22.11.2019.
//  Copyright © 2019 Mehmet Baran. All rights reserved.
//

import UIKit

class TipsTableViewCell: UITableViewCell {

    @IBOutlet weak var tipsLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
