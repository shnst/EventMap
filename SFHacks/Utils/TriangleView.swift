//
//  TriangleView.swift
//  SFHacks
//
//  Created by Shun Sato on 3/3/19.
//  Copyright © 2019 ShunSato. All rights reserved.
//

import UIKit

class TriangleView : UIView {
    private var originalBackgroundColor: UIColor?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        originalBackgroundColor = backgroundColor
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        originalBackgroundColor = backgroundColor
        backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        
        context.beginPath()
        context.move(to: CGPoint(x: rect.minX, y: rect.minY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.maxY))
        context.closePath()
        
        if originalBackgroundColor != nil {
            context.setFillColor(originalBackgroundColor!.cgColor)
        }
        
        context.fillPath()
    }
}
