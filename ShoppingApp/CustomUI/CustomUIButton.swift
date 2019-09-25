//
//  CustomUIButton.swift
//  ShoppingApp
//
//  Created by Fazlan on 9/16/19.
//  Copyright © 2019 Fazlan. All rights reserved.
//


import UIKit


@IBDesignable
class CustomButton: UIButton {
    
    //customizable uibutton controls and unlocking the designable features on attribute inspector
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadious: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadious
        }
    }
}
