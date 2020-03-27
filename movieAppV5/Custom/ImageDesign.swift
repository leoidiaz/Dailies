//
//  ImageDesign.swift
//  movieAppV3
//
//  Created by Leonardo Diaz on 2/24/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit

class ImageDesign: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImage()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupImage()
    }
    
    func setupImage(){
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
    
}
