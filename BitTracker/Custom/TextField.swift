//
//  TextField.swift
//  BitTracker
//
//  Created by Rauan on 10/6/19.
//  Copyright © 2019 Rauan. All rights reserved.
//

import UIKit

class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 5)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.borderWidth = 0.75
        self.layer.borderColor = #colorLiteral(red: 0.2187439501, green: 0.3403074145, blue: 0.3791923523, alpha: 1)
        self.layer.cornerRadius = 20
        self.borderStyle = .none
    }
}
