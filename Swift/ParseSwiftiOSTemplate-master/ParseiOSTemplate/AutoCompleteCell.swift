//
//  AutoCompleteCell.swift
//  FoodOnYourMind_Swift
//
//  Created by alec on 8/2/15.
//  Copyright (c) 2015 Computer. All rights reserved.
//

import UIKit

class AutoCompleteCell: UITableViewCell {

    
    @IBOutlet weak var title: UILabel!
    @IBOutlet  var id: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
