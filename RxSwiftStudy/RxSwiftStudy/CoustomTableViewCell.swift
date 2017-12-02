//
//  CoustomTableViewCell.swift
//  RXTest
//
//  Created by seven on 2017/11/29.
//  Copyright © 2017年 seven. All rights reserved.
//

import UIKit

class CoustomTableViewCell: UITableViewCell {
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setContentView(content:String) -> () {
        contentLabel.text = content
    }

}
