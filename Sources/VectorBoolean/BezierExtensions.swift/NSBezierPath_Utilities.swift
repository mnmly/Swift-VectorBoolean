//
//  UIBezierPath_Boolean.swift
//  Swift VectorBoolean for iOS
//
//  Based on NSBezierPath+Boolean - Created by Andrew Finnell on 5/31/11.
//  Copyright 2011 Fortunate Bear, LLC. All rights reserved.
//
//  Created by Leslie Titze on 2015-05-19.
//  Copyright (c) 2015 Leslie Titze. All rights reserved.

import Foundation
import AppKit

extension NSBezierPath {
    /// Appends a straight line to the receiver’s path.
    open func addLine(to point: CGPoint) {
        self.line(to: point)
    }
    
    /// Adds a Bezier cubic curve to the receiver’s path.
    open func addCurve(to point: CGPoint, controlPoint1: CGPoint, controlPoint2: CGPoint) {
        self.curve(to: point, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
    }
    
    /// Appends a quadratic Bézier curve to the receiver’s path.
    open func addQuadCurve(to point: CGPoint, controlPoint: CGPoint) {
        let (d1x, d1y) = (controlPoint.x - currentPoint.x, controlPoint.y - currentPoint.y)
        let (d2x, d2y) = (point.x - controlPoint.x, point.y - controlPoint.y)
        let cp1 = CGPoint(x: controlPoint.x - d1x / 3.0, y: controlPoint.y - d1y / 3.0)
        let cp2 = CGPoint(x: controlPoint.x + d2x / 3.0, y: controlPoint.y + d2y / 3.0)
        self.curve(to: point, controlPoint1: cp1, controlPoint2: cp2)
    }
    
    /// Appends an arc to the receiver’s path.
    open func addArc(withCenter center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool) {
        let _startAngle = startAngle * 180.0 / CGFloat(Double.pi)
        let _endAngle = endAngle * 180.0 / CGFloat(Double.pi)
        appendArc(withCenter: .zero, radius: radius, startAngle: _startAngle, endAngle: _endAngle, clockwise: !clockwise)
    }
    
    /// Creates and returns a new BezierPathAlias object initialized with a rounded rectangular path.
    public convenience init(roundedRect: CGRect, cornerRadius: CGFloat) {
        self.init(roundedRect: roundedRect, xRadius: cornerRadius, yRadius: cornerRadius)
    }
    
    /// Transforms all points in the path using the specified affine transform matrix.
    open func apply(_ theTransform: CGAffineTransform) {
        let t = NSAffineTransform()
        t.transformStruct = NSAffineTransformStruct(m11: theTransform.a, m12: theTransform.b, m21: theTransform.c, m22: theTransform.d, tX: theTransform.tx, tY: theTransform.ty)
        transform(using: t as AffineTransform)
    
    }
    
    /// Creates and returns a new CGPath object initialized with the contents of the Bezier Path
    /// - Note: Implemented to match the UIKit version
    public var cgPath: CGPath {
        let path = CGMutablePath()
        var points: [CGPoint] = Array<CGPoint>(repeating: .zero, count: 3)
        for i in 0 ..< self.elementCount {
            let type = self.element(at: i, associatedPoints: &points)
            switch type {
            case .moveToBezierPathElement: path.move(to: points[0])
            case .lineToBezierPathElement: path.addLine(to: points[0])
            case .curveToBezierPathElement: path.addCurve(to: points[2], control1: points[0], control2: points[1])
            case .closePathBezierPathElement: path.closeSubpath()
            }
        }
        return path
    }
    
    public var usesEvenOddFillRule: Bool {
        set {
            self.windingRule = newValue ? .evenOddWindingRule : .nonZeroWindingRule
        }
        get {
            return self.windingRule == .evenOddWindingRule
        }
    }
}
