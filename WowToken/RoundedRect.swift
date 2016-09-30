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

    override func draw(_ rect: CGRect) {
        self.backgroundColor = UIColor.clear
        fillColor.setFill()
        var path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 5))
        path.addLine(to: CGPoint(x: 5, y: 0))
        path.addLine(to: CGPoint(x: rect.width-5, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 5))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height-5))
        path.addLine(to: CGPoint(x: rect.width-5, y: rect.height))
        path.addLine(to: CGPoint(x: 5, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height-5))
        path.close()
        path.addClip()
        path.fill()
        
        path = UIBezierPath()
        path.lineWidth = 3
        UIColor.white.setStroke()
        path.move(to: CGPoint(x: 0, y: 5))
        path.addLine(to: CGPoint(x: 5, y: 0))
        path.addLine(to: CGPoint(x: rect.width-5, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 5))
        path.stroke()
        path = UIBezierPath()
        path.lineWidth = 3
        UIColor(colorLiteralRed: 0.467, green: 0.467, blue: 0.467, alpha: 1.0).setStroke()
        path.move(to: CGPoint(x: rect.width, y: 5))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height-5))
        path.addLine(to: CGPoint(x: rect.width-5, y: rect.height))
        path.addLine(to: CGPoint(x: 5, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height-5))
        path.addLine(to: CGPoint(x: 0, y: 5))
        path.stroke()
        
    }


}
