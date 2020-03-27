//
//  CustomButton.swift
//  movieAppV3
//
//  Created by Leonardo Diaz on 2/24/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupStyle()
    }
    
    
    fileprivate func setupStyle(){
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 1.0
    }
    
    
    override var isHighlighted: Bool {
        didSet{
            if isHighlighted {
                backgroundColor = #colorLiteral(red: 0.02745098039, green: 0.8352941176, blue: 0.6705882353, alpha: 1)
            }
        }
    }
}
