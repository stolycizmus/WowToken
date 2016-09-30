//
//  GraphView.swift
//  GraphView
//
//  Created by Kadasi Mate on 2015. 11. 06..
//  Copyright © 2015. Tairpake Inc. All rights reserved.
//

import UIKit

@IBDesignable class GraphView: UIView {
    
    @IBInspectable var startColor: UIColor = UIColor.red
    @IBInspectable var endColor: UIColor = UIColor.green
    
    var graphPoints: [Double] = [4,2,6,4,5,8,3]
    var nodata = false

    override func draw(_ rect: CGRect) {
        let width = rect.width
        let height = rect.height
        
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 8.0)
        path.addClip()
        
        let context = UIGraphicsGetCurrentContext()
        let colors = [startColor.cgColor, endColor.cgColor]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let colorLocation: [CGFloat] = [0.0, 1.0]
        
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: colorLocation)
        
        var startPoint = CGPoint.zero
        var endPoint = CGPoint(x: 0, y: self.bounds.height)
        context?.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions())
        
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
        let maxValue = graphPoints.max()
        let minValue = graphPoints.min()
        let columnYPoint = { (graphPoint: Double)->CGFloat in
            var y: CGFloat = CGFloat(graphPoint-minValue!) / CGFloat(maxValue!-minValue!) * graphHeight
            y = graphHeight + topBorder - y
            return y
        }
        
        UIColor.white.setFill()
        UIColor.white.setStroke()
        
        let graphPath = UIBezierPath()
        graphPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(graphPoints[0])))
        for i in 1..<graphPoints.count {
            let nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
            graphPath.addLine(to: nextPoint)
        }
        
        context?.saveGState()
        
        let clippingPath = graphPath.copy() as! UIBezierPath
        
        clippingPath.addLine(to: CGPoint(x: columnXPoint(graphPoints.count-1), y: height))
        clippingPath.addLine(to: CGPoint(x: columnXPoint(0), y: height))
        clippingPath.close()
        clippingPath.addClip()
        
        let highestYPoint = columnYPoint(maxValue!)
        startPoint = CGPoint(x: margin, y: highestYPoint)
        endPoint = CGPoint(x: margin, y: self.bounds.height)
        context?.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions())
        
        context?.restoreGState()
        
        graphPath.lineWidth = 2.0
        graphPath.stroke()
        
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: margin, y: topBorder))
        linePath.addLine(to: CGPoint(x: width - margin, y: topBorder))
        
        linePath.move(to: CGPoint(x: margin, y: topBorder + graphHeight/2))
        linePath.addLine(to: CGPoint(x: width - margin, y: topBorder + graphHeight/2))
        
        linePath.move(to: CGPoint(x: margin, y: height - bottomBorder))
        linePath.addLine(to: CGPoint(x: width - margin, y: height - bottomBorder))
        
        linePath.move(to: CGPoint(x: margin, y: height - bottomBorder))
        linePath.addLine(to: CGPoint(x: margin, y: height - bottomBorder + 8))
        
        linePath.move(to: CGPoint(x: width/2, y: height - bottomBorder))
        linePath.addLine(to: CGPoint(x: width/2, y: height - bottomBorder + 8))
        
        linePath.move(to: CGPoint(x: width - margin, y: height - bottomBorder))
        linePath.addLine(to: CGPoint(x: width - margin, y: height - bottomBorder + 8))
        
        let color = UIColor(white: 1.0, alpha: 0.3)
        color.setStroke()
        
        linePath.lineWidth = 1.0
        linePath.stroke()
        
        }
        
    }
}
