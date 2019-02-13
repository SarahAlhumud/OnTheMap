//
//  StudentLocationTableViewCell.swift
//  OnTheMap
//
//  Created by Sarah Alhumud on 04/06/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import UIKit

class StudentLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
