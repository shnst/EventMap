//
//  UIHelper.swift
//  SFHacks
//
//  Created by Shun Sato on 3/2/19.
//  Copyright © 2019 ShunSato. All rights reserved.
//

import UIKit

@IBDesignable class IBDesignableView: UIView {
    @IBInspectable var borderUIColor: UIColor = UIColor.clear
    @IBInspectable var borderWidth: CGFloat = 2.0
    @IBInspectable var cornerRadius: CGFloat = 22.0
    
    override func draw(_ rect: CGRect) {
        self.layer.borderColor = borderUIColor.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
    }
}

@IBDesignable class IBDesignableProportionalView: UIView {
    @IBInspectable var borderUIColor: UIColor = UIColor.clear
    @IBInspectable var borderWidth: CGFloat = 2.0
    @IBInspectable var ratioOfRadiusToWidth: CGFloat = 0.5
    
    override func draw(_ rect: CGRect) {
        self.layer.borderColor = borderUIColor.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = self.frame.size.height * ratioOfRadiusToWidth
    }
}
@IBDesignable class IBDesignableLabel: UILabel {
    @IBInspectable var borderUIColor: UIColor = UIColor.clear
    @IBInspectable var borderWidth: CGFloat = 2.0
    @IBInspectable var cornerRadius: CGFloat = 22.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 5, left: cornerRadius, bottom: 5, right: cornerRadius)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.borderColor = borderUIColor.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
    }
}

@IBDesignable class IBDesignableButton: UIButton {
    @IBInspectable var borderUIColor: UIColor = UIColor.white
    @IBInspectable var borderWidth: CGFloat = 2.0
    @IBInspectable var cornerRadius: CGFloat = 22.0
    
    override func draw(_ rect: CGRect) {
        self.layer.borderColor = borderUIColor.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
    }
    
    // ボタンのテキストと背景の色を入れ替え
    func swapBackgroundAndTitleLabelColor() {
        if let titleLabel = self.titleLabel {
            let titleLabelColor = titleLabel.textColor
            self.setTitleColor(( self.layer.backgroundColor == nil ? UIColor.white : UIColor(cgColor: self.layer.backgroundColor!) ), for: UIControl.State())
            self.layer.backgroundColor = (titleLabelColor == UIColor.white ? nil : titleLabelColor?.cgColor)
        }
    }
}

@IBDesignable class IBDesignableDropShadowView: IBDesignableView {
    @IBInspectable var shadowOffset: CGSize = CGSize()
    @IBInspectable var shadowOpacity: Float = 0.0
    @IBInspectable var shadowColor: UIColor = UIColor.black
    @IBInspectable var shadowRadius: CGFloat = 10.0
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowColor = shadowColor.cgColor
        layer.shadowRadius = shadowRadius
    }
}


@IBDesignable class IBDesignableProportionalButton: UIButton {
    @IBInspectable var borderUIColor: UIColor = UIColor.clear
    @IBInspectable var borderWidth: CGFloat = 2.0
    @IBInspectable var ratioOfRadiusToWidth: CGFloat = 0.5
    
    override func draw(_ rect: CGRect) {
        self.layer.borderColor = borderUIColor.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = self.frame.size.height * ratioOfRadiusToWidth
    }
}

@IBDesignable class IBDesignableTextFieldTop: UITextField {
    @IBInspectable var borderUIColor: UIColor = UIColor.lightGray
    @IBInspectable var borderWidth: CGFloat = 1.0
    @IBInspectable var cornerRadius: CGFloat = 4.0
    
    override func draw(_ rect: CGRect) {
        self.layer.borderColor = borderUIColor.cgColor
        self.layer.borderWidth = borderWidth
        
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [UIRectCorner.topLeft, UIRectCorner.topRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 10)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 10)
    }
}

@IBDesignable class IBDesignableTextFieldBottom: UITextField {
    @IBInspectable var borderUIColor: UIColor = UIColor.lightGray
    @IBInspectable var borderWidth: CGFloat = 1.0
    @IBInspectable var cornerRadius: CGFloat = 4.0
    
    override func draw(_ rect: CGRect) {
        self.layer.borderColor = borderUIColor.cgColor
        self.layer.borderWidth = borderWidth
        
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [UIRectCorner.bottomLeft, UIRectCorner.bottomRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 10)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 10)
    }
}
