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
    
    
    override func draw(_ rect: CGRect) {
        self.backgroundColor = UIColor.clear
        let path = UIBezierPath()
        if isUp {
            path.move(to: CGPoint(x: rect.width/2, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height*0.5))
            path.addLine(to: CGPoint(x: rect.width*(2/3), y: rect.height*0.5))
            path.addLine(to: CGPoint(x: rect.width*(2/3), y: rect.height))
            path.addLine(to: CGPoint(x: rect.width*(1/3), y: rect.height))
            path.addLine(to: CGPoint(x: rect.width*(1/3), y: rect.height*0.5))
            path.addLine(to: CGPoint(x: 0, y: rect.height*0.5))
            path.close()
            UIColor.red.setFill()
        } else {
            path.move(to: CGPoint(x: rect.width/2, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height*0.5))
            path.addLine(to: CGPoint(x: rect.width*(1/3), y: rect.height*0.5))
            path.addLine(to: CGPoint(x: rect.width*(1/3), y: 0))
            path.addLine(to: CGPoint(x: rect.width*(2/3), y: 0))
            path.addLine(to: CGPoint(x: rect.width*(2/3), y: rect.height*0.5))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height*0.5))
            path.close()
            UIColor.green.setFill()
        }
        path.fill()
        
    }

}
