//
//  RoundedRect.swift
//  WowToken
//
//  Created by Kadasi Mate on 2015. 11. 22..
//  Copyright © 2015. Tairpake Inc. All rights reserved.
//

import UIKit

@IBDesignable class RoundedRect: UIView {
    
    @IBInspectable var fillColor: UIColor = UIColor(colorLiteralRed: 0.035, green: 0.043, blue: 0.133, alpha: 1.0)

    override func drawRect(rect: CGRect) {
        self.backgroundColor = UIColor.clearColor()
        fillColor.setFill()
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
        path.fill()
        
        path = UIBezierPath()
        path.lineWidth = 3
        UIColor.whiteColor().setStroke()
        path.moveToPoint(CGPoint(x: 0, y: 5))
        path.addLineToPoint(CGPoint(x: 5, y: 0))
        path.addLineToPoint(CGPoint(x: rect.width-5, y: 0))
        path.addLineToPoint(CGPoint(x: rect.width, y: 5))
        path.stroke()
        path = UIBezierPath()
        path.lineWidth = 3
        UIColor(colorLiteralRed: 0.467, green: 0.467, blue: 0.467, alpha: 1.0).setStroke()
        path.moveToPoint(CGPoint(x: rect.width, y: 5))
        path.addLineToPoint(CGPoint(x: rect.width, y: rect.height-5))
        path.addLineToPoint(CGPoint(x: rect.width-5, y: rect.height))
        path.addLineToPoint(CGPoint(x: 5, y: rect.height))
        path.addLineToPoint(CGPoint(x: 0, y: rect.height-5))
        path.addLineToPoint(CGPoint(x: 0, y: 5))
        path.stroke()
        
    }


}
