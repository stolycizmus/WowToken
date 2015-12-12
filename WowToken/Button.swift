//
//  Button.swift
//  WowToken
//
//  Created by Kadasi Mate on 2015. 11. 28..
//  Copyright © 2015. Tairpake Inc. All rights reserved.
//

import UIKit

@IBDesignable class Button: UIButton {
    
    override func drawRect(rect: CGRect) {
        self.backgroundColor = UIColor.clearColor()
        var path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0, y: 5))
        path.addLineToPoint(CGPoint(x: 5, y: 0))
        path.addLineToPoint(CGPoint(x: rect.width-5, y: 0))
        path.addLineToPoint(CGPoint(x: rect.width, y: 5))
        path.addLineToPoint(CGPoint(x: rect.width, y: rect.height-5))
        path.addLineToPoint(CGPoint(x: rect.width-5, y: rect.height))
        path.addLineToPoint(CGPoint(x: 5, y: rect.height))
        path.addLineToPoint(CGPoint(x: 0, y: rect.height-5))
        path.closePath()
        path.addClip()
        
        path = UIBezierPath()
        path.lineWidth = 3
        UIColor(colorLiteralRed:0.349, green:0.325, blue:0.333, alpha:1.00).setStroke()
        path.moveToPoint(CGPoint(x: 0, y: 5))
        path.addLineToPoint(CGPoint(x: 5, y: 0))
        path.addLineToPoint(CGPoint(x: rect.width-5, y: 0))
        path.addLineToPoint(CGPoint(x: rect.width, y: 5))
        path.stroke()
        path = UIBezierPath()
        path.lineWidth = 3
        UIColor(colorLiteralRed: 0.200, green: 0.200, blue: 0.200, alpha: 1.0).setStroke()
        path.moveToPoint(CGPoint(x: rect.width, y: 5))
        path.addLineToPoint(CGPoint(x: rect.width, y: rect.height-5))
        path.addLineToPoint(CGPoint(x: rect.width-5, y: rect.height))
        path.addLineToPoint(CGPoint(x: 5, y: rect.height))
        path.addLineToPoint(CGPoint(x: 0, y: rect.height-5))
        path.addLineToPoint(CGPoint(x: 0, y: 5))
        path.stroke()
        
        path = UIBezierPath()
        path.lineWidth = 3
        UIColor(colorLiteralRed:0.137, green:0.024, blue:0.024, alpha:1.00).setStroke()
        path.moveToPoint(CGPoint(x: 3, y: 8))
        path.addLineToPoint(CGPoint(x: 8, y: 3))
        path.addLineToPoint(CGPoint(x: rect.width-8, y: 3))
        path.addLineToPoint(CGPoint(x: rect.width-3, y: 8))
        path.addLineToPoint(CGPoint(x: rect.width-3, y: rect.height-8))
        path.addLineToPoint(CGPoint(x: rect.width-8, y: rect.height-3))
        path.addLineToPoint(CGPoint(x: 8, y: rect.height-3))
        path.addLineToPoint(CGPoint(x: 3, y: rect.height-8))
        path.closePath()
        path.stroke()
        UIColor(colorLiteralRed:0.443, green:0.000, blue:0.000, alpha:1.00).setFill()
        path.fill()

        
    }
    
    
}
