//
//  WatchListCell.swift
//  movieAppV5
//
//  Created by Leonardo Diaz on 3/9/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit

class WatchListCell: UITableViewCell {

    @IBOutlet var myListImage: UIImageView!
    
    @IBOutlet var filmTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        myListImage.layer.cornerRadius = 5
    }

    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    

}
