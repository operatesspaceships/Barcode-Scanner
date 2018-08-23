//
//  Extensions.swift
//  Barcode Scanner Practice
//
//  Created by Pierre Liebenberg on 8/14/18.
//  Copyright © 2018 Phase 2. All rights reserved.
//

import UIKit
import AVFoundation


// MARK: - Layout Anchors
extension UIView {
    
    func setHeightAnchorTo(height: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
        self.updateConstraints()
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    func setHeightAnchorTo(heightAnchor: NSLayoutAnchor<NSLayoutDimension>, constant: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalTo: heightAnchor, constant: constant).isActive = true
        self.updateConstraints()
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    func setWidthAnchorTo(width: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
        self.updateConstraints()
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    func setWidthAnchorTo(widthAnchor: NSLayoutAnchor<NSLayoutDimension>, constant: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalTo: widthAnchor, constant: constant).isActive = true
        self.updateConstraints()
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    func setBottomAnchorTo(_ anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, constant: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.bottomAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        self.updateConstraints()
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    func setTopAnchorTo(_ anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, constant: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        self.updateConstraints()
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    
    func setLeadingAnchorTo(_ anchor: NSLayoutAnchor<NSLayoutXAxisAnchor>, constant: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        self.updateConstraints()
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    func setTrailingAnchorTo(_ anchor: NSLayoutAnchor<NSLayoutXAxisAnchor>, constant: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.trailingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        self.updateConstraints()
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    
    func setCenterXAnchorTo(_ anchor: NSLayoutAnchor<NSLayoutXAxisAnchor>, constant: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.centerXAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        self.updateConstraints()
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    
    func matchParentLayoutAnchorsFor(topAnchorConstant: CGFloat?, bottomAnchorConstant: CGFloat?, leadingAnchorConstant: CGFloat?, trailingAnchorConstant: CGFloat?) {
        
        if let superview = self.superview {
            
            self.translatesAutoresizingMaskIntoConstraints = false
            
            if let topAnchorConstant = topAnchorConstant {
                self.topAnchor.constraint(equalTo: superview.topAnchor, constant: topAnchorConstant).isActive = true
            }
            if let bottomAnchorConstant = bottomAnchorConstant {
                self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: bottomAnchorConstant).isActive = true
            }
            if let leadingAnchorConstant = leadingAnchorConstant {
                self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leadingAnchorConstant).isActive = true
            }
            if let trailingAnchorConstant = trailingAnchorConstant {
                self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: trailingAnchorConstant).isActive = true
            }
            
            self.updateConstraints()
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
        
    }
    
}

// MARK: - URLSession response handlers
extension URLSession {
    fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(try? JSONDecoder().decode(T.self, from: data), response, nil)
        }
    }
    
    func bookFallBackTask(with url: URL, completionHandler: @escaping (FallBackBook?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
    
    func bookDataTask(with url: URL, completionHandler: @escaping (BookSearch?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}


extension UIViewController {
    /// A helper function to add child view controller.
    func add(childViewController: UIViewController) {
        childViewController.willMove(toParentViewController: self)
        addChildViewController(childViewController)
        view.addSubview(childViewController.view)
        childViewController.didMove(toParentViewController: self)
    }
}


extension AVMetadataObject.ObjectType {
    public static let upca: AVMetadataObject.ObjectType = .init(rawValue: "org.gs1.UPC-A")
    
    /// `AVCaptureMetadataOutput` metadata object types.
    public static let barcodeScannerMetadataTypes = [
        AVMetadataObject.ObjectType.aztec,
        AVMetadataObject.ObjectType.code128,
        AVMetadataObject.ObjectType.code39,
        AVMetadataObject.ObjectType.code39Mod43,
        AVMetadataObject.ObjectType.code93,
        AVMetadataObject.ObjectType.dataMatrix,
        AVMetadataObject.ObjectType.ean13,
        AVMetadataObject.ObjectType.ean8,
        AVMetadataObject.ObjectType.face,
        AVMetadataObject.ObjectType.interleaved2of5,
        AVMetadataObject.ObjectType.itf14,
        AVMetadataObject.ObjectType.pdf417,
        AVMetadataObject.ObjectType.qr,
        AVMetadataObject.ObjectType.upce
        
        
    ]
}
