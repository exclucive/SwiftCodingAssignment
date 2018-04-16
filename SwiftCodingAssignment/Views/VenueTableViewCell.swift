//
//  VenueTableViewCell.swift
//
//  Created by Igor Novik on 2018-03-19.
//  Copyright © 2018 NAppsLab. All rights reserved.
//

import UIKit

class VenueTableViewCell: UITableViewCell {

    static let cellIdentifier = "VenueTableViewCell"
    
    @IBOutlet weak var venueIconImageView: UIImageView!
    @IBOutlet weak var venueNameLabel: UILabel!
    @IBOutlet weak var venueAddressLabel: UILabel!
    @IBOutlet weak var venuePhoneLabel: UILabel!
    @IBOutlet weak var venueDistanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
