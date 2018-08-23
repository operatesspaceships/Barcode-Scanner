//
//  AnimatableBarcodeView.swift
//  Barcode Scanner Practice
//
//  Created by Pierre Liebenberg on 8/20/18.
//  Copyright © 2018 Phase 2. All rights reserved.
//

import UIKit

class AnimatableBarcodeView: UIView {
    
    private var barcodeLines = [UIView]()
    
    weak var delegate: ScannerViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        print("AnimatableBarcodeView deinitialized.")
    }
    
    
}

// Private Functions
extension AnimatableBarcodeView {
    
    private func setUp() {
        self.backgroundColor = .clear
        let lines = self.createBarCodeVerticalLines()
        self.addVerticalLinesToBarcodeView(lines: lines)
    }
    
    private func animateBarcode() {
        
        var delay = 0.0
        
        let options: UIView.AnimationOptions = [
            .repeat,
            .autoreverse,
            .beginFromCurrentState,
            .preferredFramesPerSecond60
        ]
        
        for line in self.barcodeLines {
            UIView.animate(withDuration: 0.55, delay: delay, usingSpringWithDamping: 0.42, initialSpringVelocity: 9.15, options: options, animations: {
                
                line.transform = CGAffineTransform(translationX: 0, y: -5)
                
            }, completion: nil)
            
            delay += 0.1
        }
    }
    
    private func createBarCodeVerticalLines() -> [UIView] {
        
        let line1 = UIView()
        let line2 = UIView()
        let line3 = UIView()
        let line4 = UIView()
        let line5 = UIView()
        
        line1.frame = CGRect(x: 0, y: 0, width: 2, height: 22)
        line2.frame = CGRect(x: 4, y: 0, width: 2, height: 22)
        line3.frame = CGRect(x: 8, y: 0, width: 5, height: 22)
        line4.frame = CGRect(x: 15, y: 0, width: 3, height: 22)
        line5.frame = CGRect(x: 20, y: 0, width: 2, height: 22)
        
        line1.backgroundColor = .green
        line2.backgroundColor = .green
        line3.backgroundColor = .green
        line4.backgroundColor = .green
        line5.backgroundColor = .green
        
        barcodeLines.append(line1)
        barcodeLines.append(line2)
        barcodeLines.append(line3)
        barcodeLines.append(line4)
        barcodeLines.append(line5)
        
        return barcodeLines
    }
    
    
    private func addVerticalLinesToBarcodeView(lines: [UIView]) {
        for line in lines {
            self.addSubview(line)
        }
    }
}



// Public Functions
extension AnimatableBarcodeView {
    
    public func startAnimation() {
        animateBarcode()
    }
    
    public func stopAnimation() {
        self.layer.removeAllAnimations()
        self.removeFromSuperview()
    }
    
}
