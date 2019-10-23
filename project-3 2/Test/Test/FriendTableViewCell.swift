//
//  FriendTableViewCell.swift
//  Test
//
//  Created by Gireesh Mahajan on 5/4/17.
//  Copyright © 2017 Gireesh Mahajan. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {
    
    @IBOutlet var imageCell: UIImageView!
    @IBOutlet var lebelCell: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
