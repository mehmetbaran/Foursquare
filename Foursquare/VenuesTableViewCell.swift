//
//  VenuesTableViewCell.swift
//  Foursquare
//
//  Created by Mehmet Baran on 21.11.2019.
//  Copyright © 2019 Mehmet Baran. All rights reserved.
//

import UIKit

class VenuesTableViewCell: UITableViewCell {
    
    //MARK: -IBOutlets
    
    @IBOutlet weak var venuesName: UILabel!
    @IBOutlet weak var venuesAddress: UILabel!
    @IBOutlet weak var venuesCity: UILabel!
    @IBOutlet weak var venuesCountry: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
