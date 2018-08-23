//
//  DrawingAssets.swift
//  Barcode Scanner
//
//  Created by Pierre Liebenberg on 8/16/18.
//  Copyright © 2018 Phase 2. All rights reserved.
//
//  Generated by PaintCode
//  http://www.paintcodeapp.com
//



import UIKit

public class DrawingAssets : NSObject {

    //// Drawing Methods

    @objc dynamic public class func drawRescanButton(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 21, height: 21), resizing: ResizingBehavior = .aspectFit) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 21, height: 21), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 21, y: resizedFrame.height / 21)


        //// Color Declarations
        let lightFillColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)

        //// RescanButtonShape Drawing
        let rescanButtonShapePath = UIBezierPath()
        rescanButtonShapePath.move(to: CGPoint(x: 10.5, y: -0))
        rescanButtonShapePath.addCurve(to: CGPoint(x: 9.73, y: 0.43), controlPoint1: CGPoint(x: 10.18, y: -0), controlPoint2: CGPoint(x: 9.89, y: 0.16))
        rescanButtonShapePath.addCurve(to: CGPoint(x: 9.73, y: 1.32), controlPoint1: CGPoint(x: 9.57, y: 0.71), controlPoint2: CGPoint(x: 9.57, y: 1.04))
        rescanButtonShapePath.addCurve(to: CGPoint(x: 10.5, y: 1.75), controlPoint1: CGPoint(x: 9.89, y: 1.59), controlPoint2: CGPoint(x: 10.18, y: 1.75))
        rescanButtonShapePath.addCurve(to: CGPoint(x: 19.25, y: 10.5), controlPoint1: CGPoint(x: 15.34, y: 1.75), controlPoint2: CGPoint(x: 19.25, y: 5.66))
        rescanButtonShapePath.addCurve(to: CGPoint(x: 10.5, y: 19.25), controlPoint1: CGPoint(x: 19.25, y: 15.34), controlPoint2: CGPoint(x: 15.34, y: 19.25))
        rescanButtonShapePath.addCurve(to: CGPoint(x: 1.75, y: 10.5), controlPoint1: CGPoint(x: 5.66, y: 19.25), controlPoint2: CGPoint(x: 1.75, y: 15.34))
        rescanButtonShapePath.addCurve(to: CGPoint(x: 3.64, y: 5.07), controlPoint1: CGPoint(x: 1.75, y: 8.44), controlPoint2: CGPoint(x: 2.46, y: 6.56))
        rescanButtonShapePath.addLine(to: CGPoint(x: 5.25, y: 7))
        rescanButtonShapePath.addLine(to: CGPoint(x: 7, y: 0.87))
        rescanButtonShapePath.addLine(to: CGPoint(x: 0.87, y: 1.75))
        rescanButtonShapePath.addLine(to: CGPoint(x: 2.51, y: 3.71))
        rescanButtonShapePath.addCurve(to: CGPoint(x: 0, y: 10.5), controlPoint1: CGPoint(x: 0.95, y: 5.54), controlPoint2: CGPoint(x: 0, y: 7.91))
        rescanButtonShapePath.addCurve(to: CGPoint(x: 10.5, y: 21), controlPoint1: CGPoint(x: 0, y: 16.29), controlPoint2: CGPoint(x: 4.71, y: 21))
        rescanButtonShapePath.addCurve(to: CGPoint(x: 21, y: 10.5), controlPoint1: CGPoint(x: 16.29, y: 21), controlPoint2: CGPoint(x: 21, y: 16.29))
        rescanButtonShapePath.addCurve(to: CGPoint(x: 10.5, y: -0), controlPoint1: CGPoint(x: 21, y: 4.71), controlPoint2: CGPoint(x: 16.29, y: -0))
        rescanButtonShapePath.close()
        lightFillColor.setFill()
        rescanButtonShapePath.fill()
        
        context.restoreGState()

    }

    @objc dynamic public class func drawBackButton(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 21, height: 21), resizing: ResizingBehavior = .aspectFit) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 21, height: 21), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 21, y: resizedFrame.height / 21)


        //// Color Declarations
        let lightFillColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)

        //// BackButtonShape Drawing
        let backButtonShapePath = UIBezierPath()
        backButtonShapePath.move(to: CGPoint(x: 13.54, y: 20.57))
        backButtonShapePath.addLine(to: CGPoint(x: 4.29, y: 11.21))
        backButtonShapePath.addCurve(to: CGPoint(x: 4.29, y: 9.79), controlPoint1: CGPoint(x: 3.9, y: 10.82), controlPoint2: CGPoint(x: 3.9, y: 10.18))
        backButtonShapePath.addLine(to: CGPoint(x: 13.54, y: 0.43))
        backButtonShapePath.addCurve(to: CGPoint(x: 15.58, y: 0.43), controlPoint1: CGPoint(x: 14.1, y: -0.14), controlPoint2: CGPoint(x: 15.01, y: -0.14))
        backButtonShapePath.addCurve(to: CGPoint(x: 15.58, y: 2.49), controlPoint1: CGPoint(x: 16.14, y: 1), controlPoint2: CGPoint(x: 16.14, y: 1.92))
        backButtonShapePath.addLine(to: CGPoint(x: 7.67, y: 10.5))
        backButtonShapePath.addLine(to: CGPoint(x: 15.58, y: 18.51))
        backButtonShapePath.addCurve(to: CGPoint(x: 15.58, y: 20.57), controlPoint1: CGPoint(x: 16.14, y: 19.08), controlPoint2: CGPoint(x: 16.14, y: 20))
        backButtonShapePath.addCurve(to: CGPoint(x: 13.54, y: 20.57), controlPoint1: CGPoint(x: 15.01, y: 21.14), controlPoint2: CGPoint(x: 14.1, y: 21.14))
        backButtonShapePath.close()
        backButtonShapePath.usesEvenOddFillRule = true
        lightFillColor.setFill()
        backButtonShapePath.fill()
        
        context.restoreGState()

    }

    @objc dynamic public class func drawFlashlightButton(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 12, height: 26), resizing: ResizingBehavior = .aspectFit, color: UIColor? = UIColor.white) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 12, height: 26), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 12, y: resizedFrame.height / 26)


        //// Color Declarations
        let lightFillColor = color //UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)

        //// FlashlightShape Drawing
        let flashlightShapePath = UIBezierPath()
        flashlightShapePath.move(to: CGPoint(x: 1, y: 0))
        flashlightShapePath.addCurve(to: CGPoint(x: 0, y: 1), controlPoint1: CGPoint(x: 0.45, y: 0), controlPoint2: CGPoint(x: 0, y: 0.45))
        flashlightShapePath.addLine(to: CGPoint(x: 0, y: 2))
        flashlightShapePath.addLine(to: CGPoint(x: 12, y: 2))
        flashlightShapePath.addLine(to: CGPoint(x: 12, y: 1))
        flashlightShapePath.addCurve(to: CGPoint(x: 11, y: 0), controlPoint1: CGPoint(x: 12, y: 0.45), controlPoint2: CGPoint(x: 11.55, y: 0))
        flashlightShapePath.addLine(to: CGPoint(x: 1, y: 0))
        flashlightShapePath.close()
        flashlightShapePath.move(to: CGPoint(x: 0, y: 3))
        flashlightShapePath.addLine(to: CGPoint(x: 0, y: 5.09))
        flashlightShapePath.addCurve(to: CGPoint(x: 0.5, y: 6.76), controlPoint1: CGPoint(x: 0, y: 5.68), controlPoint2: CGPoint(x: 0.17, y: 6.26))
        flashlightShapePath.addLine(to: CGPoint(x: 1.33, y: 7.99))
        flashlightShapePath.addCurve(to: CGPoint(x: 2, y: 10.21), controlPoint1: CGPoint(x: 1.77, y: 8.65), controlPoint2: CGPoint(x: 2, y: 9.42))
        flashlightShapePath.addLine(to: CGPoint(x: 2, y: 24))
        flashlightShapePath.addCurve(to: CGPoint(x: 4, y: 26), controlPoint1: CGPoint(x: 2, y: 25.11), controlPoint2: CGPoint(x: 2.9, y: 26))
        flashlightShapePath.addLine(to: CGPoint(x: 8, y: 26))
        flashlightShapePath.addCurve(to: CGPoint(x: 10, y: 24), controlPoint1: CGPoint(x: 9.11, y: 26), controlPoint2: CGPoint(x: 10, y: 25.11))
        flashlightShapePath.addLine(to: CGPoint(x: 10, y: 10.21))
        flashlightShapePath.addCurve(to: CGPoint(x: 10.67, y: 7.99), controlPoint1: CGPoint(x: 10, y: 9.42), controlPoint2: CGPoint(x: 10.23, y: 8.65))
        flashlightShapePath.addLine(to: CGPoint(x: 11.5, y: 6.76))
        flashlightShapePath.addCurve(to: CGPoint(x: 12, y: 5.09), controlPoint1: CGPoint(x: 11.83, y: 6.26), controlPoint2: CGPoint(x: 12, y: 5.68))
        flashlightShapePath.addLine(to: CGPoint(x: 12, y: 3))
        flashlightShapePath.addLine(to: CGPoint(x: 0, y: 3))
        flashlightShapePath.close()
        flashlightShapePath.move(to: CGPoint(x: 6, y: 10))
        flashlightShapePath.addCurve(to: CGPoint(x: 8, y: 12), controlPoint1: CGPoint(x: 7.11, y: 10), controlPoint2: CGPoint(x: 8, y: 10.89))
        flashlightShapePath.addLine(to: CGPoint(x: 8, y: 14))
        flashlightShapePath.addCurve(to: CGPoint(x: 6, y: 16), controlPoint1: CGPoint(x: 8, y: 15.11), controlPoint2: CGPoint(x: 7.11, y: 16))
        flashlightShapePath.addCurve(to: CGPoint(x: 4, y: 14), controlPoint1: CGPoint(x: 4.9, y: 16), controlPoint2: CGPoint(x: 4, y: 15.11))
        flashlightShapePath.addLine(to: CGPoint(x: 4, y: 12))
        flashlightShapePath.addCurve(to: CGPoint(x: 6, y: 10), controlPoint1: CGPoint(x: 4, y: 10.89), controlPoint2: CGPoint(x: 4.9, y: 10))
        flashlightShapePath.close()
        flashlightShapePath.move(to: CGPoint(x: 6, y: 13))
        flashlightShapePath.addCurve(to: CGPoint(x: 5, y: 14), controlPoint1: CGPoint(x: 5.45, y: 13), controlPoint2: CGPoint(x: 5, y: 13.45))
        flashlightShapePath.addCurve(to: CGPoint(x: 6, y: 15), controlPoint1: CGPoint(x: 5, y: 14.55), controlPoint2: CGPoint(x: 5.45, y: 15))
        flashlightShapePath.addCurve(to: CGPoint(x: 7, y: 14), controlPoint1: CGPoint(x: 6.55, y: 15), controlPoint2: CGPoint(x: 7, y: 14.55))
        flashlightShapePath.addCurve(to: CGPoint(x: 6, y: 13), controlPoint1: CGPoint(x: 7, y: 13.45), controlPoint2: CGPoint(x: 6.55, y: 13))
        flashlightShapePath.close()
        lightFillColor?.setFill()
        flashlightShapePath.fill()
        
        context.restoreGState()

    }




    @objc(DrawingAssetsResizingBehavior)
    public enum ResizingBehavior: Int {
        case aspectFit /// The content is proportionally resized to fit into the target rectangle.
        case aspectFill /// The content is proportionally resized to completely fill the target rectangle.
        case stretch /// The content is stretched to match the entire target rectangle.
        case center /// The content is centered in the target rectangle, but it is NOT resized.

        public func apply(rect: CGRect, target: CGRect) -> CGRect {
            if rect == target || target == CGRect.zero {
                return rect
            }

            var scales = CGSize.zero
            scales.width = abs(target.width / rect.width)
            scales.height = abs(target.height / rect.height)

            switch self {
                case .aspectFit:
                    scales.width = min(scales.width, scales.height)
                    scales.height = scales.width
                case .aspectFill:
                    scales.width = max(scales.width, scales.height)
                    scales.height = scales.width
                case .stretch:
                    break
                case .center:
                    scales.width = 1
                    scales.height = 1
            }

            var result = rect.standardized
            result.size.width *= scales.width
            result.size.height *= scales.height
            result.origin.x = target.minX + (target.width - result.width) / 2
            result.origin.y = target.minY + (target.height - result.height) / 2
            return result
        }
    }
}