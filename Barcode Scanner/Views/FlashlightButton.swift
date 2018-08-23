//
//  FlashlightButton.swift
//  Barcode Scanner Practice
//
//  Created by Pierre Liebenberg on 8/16/18.
//  Copyright © 2018 Phase 2. All rights reserved.
//

import UIKit

@IBDesignable class FlashlightButton: UIButton {

    var isOn: Bool = false {
        didSet {
            if isOn {
                self.buttonIconColor = UIColor.green
            } else {
                self.buttonIconColor = UIColor.white
            }
            self.setNeedsDisplay()
        }
    }
    
    var buttonIconColor: UIColor = UIColor.white
    
    override func draw(_ rect: CGRect) {
        DrawingAssets.drawFlashlightButton(frame: rect, resizing: .center, color: self.buttonIconColor)
    }
    
    
}
