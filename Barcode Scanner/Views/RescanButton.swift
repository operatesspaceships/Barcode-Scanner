//
//  RescanButton.swift
//  Barcode Scanner Practice
//
//  Created by Pierre Liebenberg on 8/13/18.
//  Copyright © 2018 Phase 2. All rights reserved.
//

import UIKit

@IBDesignable class RescanButton: UIButton {

   
    override func draw(_ rect: CGRect) {
        DrawingAssets.drawRescanButton(frame: rect, resizing: .center)
    }
   

}
