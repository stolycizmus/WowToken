//
//  GraphView.swift
//  GraphView
//
//  Created by Kadasi Mate on 2015. 11. 06..
//  Copyright © 2015. Tairpake Inc. All rights reserved.
//

import UIKit

@IBDesignable class GraphView: UIView {
    
    @IBInspectable var startColor: UIColor = UIColor.redColor()
    @IBInspectable var endColor: UIColor = UIColor.greenColor()
    
    var graphPoints: [Double] = [4,2,6,4,5,8,3]
    var nodata = false

    override func drawRect(rect: CGRect) {
        let width = rect.width
        let height = rect.height
        
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 8.0)
        path.addClip()
        
        let context = UIGraphicsGetCurrentContext()
        let colors = [startColor.CGColor, endColor.CGColor]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let colorLocation: [CGFloat] = [0.0, 1.0]
        
        let gradient = CGGradientCreateWithColors(colorSpace, colors, colorLocation)
        
        var startPoint = CGPoint.zero
        var endPoint = CGPoint(x: 0, y: self.bounds.height)
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, CGGradientDrawingOptions())
        
        //check if graphview should load with or without graph points (data)
        if !nodata {
        
        let margin: CGFloat = width*0.15
        let columnXPoint = { (column: Int)->CGFloat in
            let spacer = (width - margin*2 - 4) / CGFloat(self.graphPoints.count - 1)
            var x: CGFloat = CGFloat(column)*spacer
            x += margin+2
            return x
        }
        
        let topBorder: CGFloat = height*0.2
        let bottomBorder: CGFloat = height*0.2
        let graphHeight = height - topBorder - bottomBorder
        let maxValue = graphPoints.maxElement()
        let minValue = graphPoints.minElement()
        let columnYPoint = { (graphPoint: Double)->CGFloat in
            var y: CGFloat = CGFloat(graphPoint-minValue!) / CGFloat(maxValue!-minValue!) * graphHeight
            y = graphHeight + topBorder - y
            return y
        }
        
        UIColor.whiteColor().setFill()
        UIColor.whiteColor().setStroke()
        
        let graphPath = UIBezierPath()
        graphPath.moveToPoint(CGPoint(x: columnXPoint(0), y: columnYPoint(graphPoints[0])))
        for i in 1..<graphPoints.count {
            let nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
            graphPath.addLineToPoint(nextPoint)
        }
        
        CGContextSaveGState(context)
        
        let clippingPath = graphPath.copy() as! UIBezierPath
        
        clippingPath.addLineToPoint(CGPoint(x: columnXPoint(graphPoints.count-1), y: height))
        clippingPath.addLineToPoint(CGPoint(x: columnXPoint(0), y: height))
        clippingPath.closePath()
        clippingPath.addClip()
        
        let highestYPoint = columnYPoint(maxValue!)
        startPoint = CGPoint(x: margin, y: highestYPoint)
        endPoint = CGPoint(x: margin, y: self.bounds.height)
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, CGGradientDrawingOptions())
        
        CGContextRestoreGState(context)
        
        graphPath.lineWidth = 2.0
        graphPath.stroke()
        
        let linePath = UIBezierPath()
        linePath.moveToPoint(CGPoint(x: margin, y: topBorder))
        linePath.addLineToPoint(CGPoint(x: width - margin, y: topBorder))
        
        linePath.moveToPoint(CGPoint(x: margin, y: topBorder + graphHeight/2))
        linePath.addLineToPoint(CGPoint(x: width - margin, y: topBorder + graphHeight/2))
        
        linePath.moveToPoint(CGPoint(x: margin, y: height - bottomBorder))
        linePath.addLineToPoint(CGPoint(x: width - margin, y: height - bottomBorder))
        
        linePath.moveToPoint(CGPoint(x: margin, y: height - bottomBorder))
        linePath.addLineToPoint(CGPoint(x: margin, y: height - bottomBorder + 8))
        
        linePath.moveToPoint(CGPoint(x: width/2, y: height - bottomBorder))
        linePath.addLineToPoint(CGPoint(x: width/2, y: height - bottomBorder + 8))
        
        linePath.moveToPoint(CGPoint(x: width - margin, y: height - bottomBorder))
        linePath.addLineToPoint(CGPoint(x: width - margin, y: height - bottomBorder + 8))
        
        let color = UIColor(white: 1.0, alpha: 0.3)
        color.setStroke()
        
        linePath.lineWidth = 1.0
        linePath.stroke()
        
        }
        
    }
}