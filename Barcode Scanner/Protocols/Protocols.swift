//
//  Protocols.swift
//  Barcode Scanner Practice
//
//  Created by Pierre Liebenberg on 8/15/18.
//  Copyright © 2018 Phase 2. All rights reserved.
//

import Foundation

protocol ScannerViewControllerDelegate: class {
    func titleScannerDidReceiveResult(result: Dictionary<String, String>, forSearchCategory searchCategory: SearchCategory)
}
