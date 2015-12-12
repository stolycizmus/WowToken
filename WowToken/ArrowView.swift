//
//  ArrowView.swift
//  WowToken
//
//  Created by Kadasi Mate on 2015. 11. 22..
//  Copyright © 2015. Tairpake Inc. All rights reserved.
//

import UIKit

@IBDesignable class ArrowView: UIView {
    @IBInspectable var isUp: Bool = true
    
    
    override func drawRect(rect: CGRect) {
        self.backgroundColor = UIColor.clearColor()
        let path = UIBezierPath()
        if isUp {
            path.moveToPoint(CGPoint(x: rect.width/2, y: 0))
            path.addLineToPoint(CGPoint(x: rect.width, y: rect.height*0.5))
            path.addLineToPoint(CGPoint(x: rect.width*(2/3), y: rect.height*0.5))
            path.addLineToPoint(CGPoint(x: rect.width*(2/3), y: rect.height))
            path.addLineToPoint(CGPoint(x: rect.width*(1/3), y: rect.height))
            path.addLineToPoint(CGPoint(x: rect.width*(1/3), y: rect.height*0.5))
            path.addLineToPoint(CGPoint(x: 0, y: rect.height*0.5))
            path.closePath()
            UIColor.redColor().setFill()
        } else {
            path.moveToPoint(CGPoint(x: rect.width/2, y: rect.height))
            path.addLineToPoint(CGPoint(x: 0, y: rect.height*0.5))
            path.addLineToPoint(CGPoint(x: rect.width*(1/3), y: rect.height*0.5))
            path.addLineToPoint(CGPoint(x: rect.width*(1/3), y: 0))
            path.addLineToPoint(CGPoint(x: rect.width*(2/3), y: 0))
            path.addLineToPoint(CGPoint(x: rect.width*(2/3), y: rect.height*0.5))
            path.addLineToPoint(CGPoint(x: rect.width, y: rect.height*0.5))
            path.closePath()
            UIColor.greenColor().setFill()
        }
        path.fill()
        
    }

}
