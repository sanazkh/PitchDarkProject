//
//  PostCell.swift
//  Instagram
//
//  Created by Sanaz Khosravi on 10/1/18.
//  Copyright © 2018 GirlsWhoCode. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    
    @IBOutlet var captionText: UITextView!
    @IBOutlet var imageViewCell: UIImageView!
    @IBOutlet var locationLabel: UILabel!
    
    var indexpath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
