//
//  listCell.swift
//  TableDemo
//
//  Created by Alec on 6/21/15.
//  Copyright (c) 2015 alec. All rights reserved.
//

import Foundation
import UIKit

class listCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var checkedImage: UIImageView!
    
    var recipie:String = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
