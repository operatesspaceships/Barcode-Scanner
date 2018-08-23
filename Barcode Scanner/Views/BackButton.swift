//
//  BackButton.swift
//  Barcode Scanner Practice
//
//  Created by Pierre Liebenberg on 8/14/18.
//  Copyright © 2018 Phase 2. All rights reserved.
//

import UIKit


@IBDesignable class BackButton: UIButton {
    
    override func draw(_ rect: CGRect) {
        DrawingAssets.drawBackButton(frame: rect, resizing: .center)
    }
    
}
