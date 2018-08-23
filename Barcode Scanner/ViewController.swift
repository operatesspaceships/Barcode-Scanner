//
//  ViewController.swift
//  Barcode Scanner Practice
//
//  Created by Pierre Liebenberg on 8/21/18.
//  Copyright © 2018 Phase 2. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet var ISBNLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var searchTypeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func scanTitle(_ sender: Any) {
        
        
        
        let scannerViewController = ScannerViewController()
        scannerViewController.delegate = self
        
        /*if let googleBooksAPIKey = UserDefaults.value(forKey: "apikey") as? String {
         
            scannerViewController.googleBooksAPIKey = googleBooksAPIKey
        }*/
        
        present(scannerViewController, animated: true, completion: nil)
    }

}

extension ViewController: ScannerViewControllerDelegate {
    
    func titleScannerDidReceiveResult(result: Dictionary<String, String>, forSearchCategory searchCategory: SearchCategory) {
        
        self.titleLabel.text = result["title"]
        self.ISBNLabel.text = result["ISBN"]
        self.searchTypeLabel.text = searchCategory.rawValue
        
    }
    
    
}
