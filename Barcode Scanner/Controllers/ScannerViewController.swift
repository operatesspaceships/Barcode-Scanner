//
//  ViewController.swift
//  Barcode Scanner Practice
//
//  Created by Pierre Liebenberg on 8/13/18.
//  Copyright © 2018 Phase 2. All rights reserved.
//

import AVFoundation
import UIKit

class ScannerViewController: UIViewController {
    
    // MARK: - Public Properties
    weak var delegate: ScannerViewControllerDelegate?
    var googleBooksAPIKey: String = ""
    var shouldUseTestData: Bool = false
    
    // MARK: - Private Properties
    // UI
    private var scanView = UIView()
    private var focusView = UIView()
    private var backButton = UIView()
    private var rescanButton = UIView()
    private var flashLightButtonContainer = UIView()
    private var flashLightButton = FlashlightButton()
    private var instructionLabel = UILabel()
    private var instructionLabelContainer = UIView()
    private var errorLabel = UILabel()
    private var errorLabelContainer = UIView()
    
    // Confirmation Card
    let confirmationCard = UIView()
    let confirmationCardImageContainer = UIView()
    let confirmationCardImage = UIImageView()
    let bookTitleLabel = UILabel()
    let authorNameLabel = UILabel()
    let confirmationCardLabelsContainer = UIStackView()
    let confirmationCardInstructionLabel = UILabel()
    let confirmationCardButtonContainer = UIView()
    let confirmationCardContentStackView = UIStackView()
    
    // State
    private enum ScanningState {
        case scanning
        case recognized
        case success
        case error
    }
    
    private var flashlightIsOn: Bool = false
    
    private var scanningState: ScanningState = .scanning {
        didSet {
            DispatchQueue.main.async {
                self.updateUIForState()
            }
        }
    }
    
    private var shouldProceedWithScanning: Bool = true
    private var confirmationCardIsVisible = false
    
    // Capture
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    // Data Points
    private var bookInformationURL: URL?
    private var bookTitle: String = ""
    private var ISBN: String = ""
    
    // Barcode Processing Animation
    private lazy var barcodeView: AnimatableBarcodeView = AnimatableBarcodeView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        
        self.setUpFocusView()
        self.makeScanView()
        self.makeInstructionLabelContainer()
        self.makeErrorLabelContainer()
        self.makeConfirmationCard()
        self.setUpButtons()
        self.setUpCaptureSession()
        let distance = self.view.frame.maxY - confirmationCard.frame.minY + 20
        self.confirmationCard.transform = CGAffineTransform(translationX: 0, y: distance)
        self.view.bringSubview(toFront: confirmationCard)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
        
        self.setUpObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let options: UIView.AnimationOptions = [
            .repeat,
            .autoreverse,
            .beginFromCurrentState,
            .preferredFramesPerSecond60
        ]
        
        self.animateFocusView(withDuration: 1.5, andOptions: options) {
            
            self.focusView.layer.borderColor = UIColor.white.cgColor
            self.focusView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
  
    }
    
    @objc func appMovedToBackground() {
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
        
        if flashlightIsOn {
            handleFlashlightButtonTap()
        }
    
    }
    
    @objc func appMovedToForeground() {
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    // MARK: - Setup
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    private func setUpObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    private func makeScanView() {
        self.scanView = UIView(frame: self.view.bounds)
        self.view.addSubview(scanView)
        self.view.sendSubview(toBack: self.scanView)
        
        self.scanView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleScanViewTap(_:)))
        scanView.addGestureRecognizer(tapGestureRecognizer)
        
        scanView.translatesAutoresizingMaskIntoConstraints = false
        scanView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scanView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        scanView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        scanView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        scanView.updateConstraints()
        scanView.setNeedsLayout()
    }
    
    private func makeConfirmationCard() {
        
        self.view.addSubview(confirmationCard)
        
        confirmationCard.autoresizesSubviews = true
        confirmationCard.clipsToBounds = true
        confirmationCard.matchParentLayoutAnchorsFor(topAnchorConstant: nil, bottomAnchorConstant: -42, leadingAnchorConstant: 18, trailingAnchorConstant: -18)
        confirmationCard.setHeightAnchorTo(height: 251)
        confirmationCard.setCenterXAnchorTo(self.view.centerXAnchor, constant: 0)
        
        
        // Blur Views
        // 1
        let blurEffect = UIBlurEffect(style: .light)
        let backBlurredEffectView = UIVisualEffectView(effect: blurEffect)
        backBlurredEffectView.frame = confirmationCard.bounds
        confirmationCard.addSubview(backBlurredEffectView)
        
        backBlurredEffectView.matchParentLayoutAnchorsFor(topAnchorConstant: 0, bottomAnchorConstant: 0, leadingAnchorConstant: 0, trailingAnchorConstant: 0)
        
        // 2
        let vibrancyEffect = UIBlurEffect(style: .light)
        let frontBlurredEffectView = UIVisualEffectView(effect: vibrancyEffect)
        frontBlurredEffectView.frame = confirmationCard.bounds
        backBlurredEffectView.contentView.addSubview(frontBlurredEffectView)
        
        frontBlurredEffectView.matchParentLayoutAnchorsFor(topAnchorConstant: 0, bottomAnchorConstant: 0, leadingAnchorConstant: 0, trailingAnchorConstant: 0)
        
        
        // Button Container
        frontBlurredEffectView.contentView.addSubview(confirmationCardButtonContainer)
        confirmationCardButtonContainer.frame = CGRect(x: 0, y: 55, width: 339, height: 55)
        confirmationCardButtonContainer.matchParentLayoutAnchorsFor(topAnchorConstant: nil, bottomAnchorConstant: 0, leadingAnchorConstant: 0, trailingAnchorConstant: 0)
        confirmationCardButtonContainer.setHeightAnchorTo(height: 55)
        confirmationCardButtonContainer.setWidthAnchorTo(widthAnchor: confirmationCard.widthAnchor, constant: 0)
        confirmationCardButtonContainer.backgroundColor = UIColor.white.withAlphaComponent(0.37)
        
        // Print Button
        let buttonWidth = confirmationCardButtonContainer.bounds.width / 2
        let printButton = UIButton()
        printButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: 55)
        printButton.tintColor = .black
        printButton.setTitleColor(.black, for: .normal)
        printButton.backgroundColor = .clear
        printButton.titleLabel?.font = UIFont(name: "ProximaNova-Semibold", size: 18)
        printButton.setTitle("Print", for: .normal)
        confirmationCardButtonContainer.addSubview(printButton)
        printButton.addTarget(self, action: #selector(handlePrintButtonTap), for: .touchUpInside)
        
        // Digital Button
        let digitalButton = UIButton()
        digitalButton.frame = CGRect(x: buttonWidth + 1, y: 0, width: buttonWidth, height: 55)
        digitalButton.tintColor = .black
        digitalButton.backgroundColor = .clear
        digitalButton.setTitle("Digital", for: .normal)
        digitalButton.titleLabel?.font = UIFont(name: "ProximaNova-Semibold", size: 18)
        digitalButton.setTitleColor(.black, for: .normal)
        confirmationCardButtonContainer.addSubview(digitalButton)
        digitalButton.addTarget(self, action: #selector(handleDigitalButtonTap), for: .touchUpInside)
        
        // Instruction Label
        frontBlurredEffectView.contentView.addSubview(confirmationCardInstructionLabel)
        confirmationCardInstructionLabel.frame.size = CGSize(width: 155, height: 20)
        confirmationCardInstructionLabel.text = "Search for this title in:"
        confirmationCardInstructionLabel.font = UIFont(name: "ProximaNova-Semibold", size: 16)
        confirmationCardInstructionLabel.setBottomAnchorTo(confirmationCardButtonContainer.topAnchor, constant: -10)
        confirmationCardInstructionLabel.setCenterXAnchorTo(frontBlurredEffectView.centerXAnchor, constant: 0)
        
        // StackView for Book Cover and Labels'stackView
        confirmationCardContentStackView.axis = .horizontal
        confirmationCardContentStackView.alignment = .top
        confirmationCardContentStackView.distribution = .equalSpacing
        confirmationCardContentStackView.spacing = 15
        
        frontBlurredEffectView.contentView.addSubview(confirmationCardContentStackView)
        
        confirmationCardContentStackView.matchParentLayoutAnchorsFor(topAnchorConstant: 15, bottomAnchorConstant: nil, leadingAnchorConstant: 15, trailingAnchorConstant: -15)
        confirmationCardContentStackView.setBottomAnchorTo(confirmationCardInstructionLabel.topAnchor, constant: -10)
        
        
        // Book cover image container
        confirmationCardContentStackView.addArrangedSubview(confirmationCardImageContainer)
        confirmationCardImageContainer.matchParentLayoutAnchorsFor(topAnchorConstant: 0, bottomAnchorConstant: 0, leadingAnchorConstant: 0, trailingAnchorConstant: nil)
        confirmationCardImageContainer.clipsToBounds = false
        
        // Book cover image
        confirmationCardImage.contentMode = .scaleToFill
        confirmationCardImage.frame = confirmationCardImageContainer.bounds
        confirmationCardImage.clipsToBounds = true
        
        confirmationCardImageContainer.addSubview(confirmationCardImage)
        confirmationCardImage.matchParentLayoutAnchorsFor(topAnchorConstant: 0, bottomAnchorConstant: nil, leadingAnchorConstant: 0, trailingAnchorConstant: nil)
        confirmationCardImage.heightAnchor.constraint(lessThanOrEqualToConstant: 128).isActive = true
        confirmationCardImage.widthAnchor.constraint(lessThanOrEqualToConstant: 78.66).isActive = true
        
        
        // Labels (title and author) container
        confirmationCardContentStackView.addArrangedSubview(confirmationCardLabelsContainer)
        confirmationCardLabelsContainer.axis = .vertical
        confirmationCardLabelsContainer.alignment = .leading
        confirmationCardLabelsContainer.distribution = .equalSpacing
        confirmationCardLabelsContainer.spacing = 10
        //_confirmationCardLabelsContainer.matchParentLayoutAnchorsFor(topAnchorConstant: nil, bottomAnchorConstant: nil, leadingAnchorConstant: nil, trailingAnchorConstant: -15)
        confirmationCardLabelsContainer.setLeadingAnchorTo(confirmationCardImage.trailingAnchor, constant: 15)
        
        // Label for title
        confirmationCardLabelsContainer.addArrangedSubview(bookTitleLabel)
        bookTitleLabel.lineBreakMode = .byWordWrapping
        bookTitleLabel.numberOfLines = 0
        bookTitleLabel.textAlignment = .left
        bookTitleLabel.text = "Book Title Goes Here"
        bookTitleLabel.font = UIFont(name: "ProximaNovaA-Bold", size: 19)
  
        // Label for author
        confirmationCardLabelsContainer.addArrangedSubview(authorNameLabel)
        authorNameLabel.lineBreakMode = .byWordWrapping
        authorNameLabel.numberOfLines = 0
        authorNameLabel.textAlignment = .left
        authorNameLabel.text = "Author Name Goes Here"
        authorNameLabel.font = UIFont(name: "ProximaNova-Semibold", size: 17)
       
        // Background Colours
        confirmationCard.backgroundColor = .clear
        backBlurredEffectView.backgroundColor = .clear
        frontBlurredEffectView.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        
        confirmationCard.layer.cornerRadius = 12
        
    }
    
    private func makeRescanButton() -> UIView  {
        let rescanButton = RescanButton()
        let rescanButtonContainer = UIView()
        
        rescanButtonContainer.frame = CGRect(x: self.view.frame.maxX - 113, y: 44, width: 93, height: 55)
        rescanButtonContainer.backgroundColor = .clear
        rescanButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        rescanButtonContainer.clipsToBounds = true
        rescanButtonContainer.autoresizesSubviews = true
        
        self.view.addSubview(rescanButtonContainer)
        self.view.bringSubview(toFront: rescanButtonContainer)
        
        rescanButtonContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        rescanButtonContainer.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 44).isActive = true
        rescanButtonContainer.widthAnchor.constraint(equalToConstant: 93).isActive = true
        rescanButtonContainer.heightAnchor.constraint(equalToConstant: 55).isActive = true
        rescanButtonContainer.updateConstraints()
        
        rescanButton.frame = rescanButtonContainer.bounds
        rescanButton.addTarget(self, action: #selector(handleRescanButtonTap), for: .touchUpInside)
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = rescanButtonContainer.bounds
        
        rescanButtonContainer.addSubview(blurredEffectView)
        blurredEffectView.contentView.addSubview(rescanButton)
        
        rescanButtonContainer.layer.cornerRadius = 15
        rescanButtonContainer.setNeedsLayout()
        rescanButtonContainer.alpha = 0
        
        return rescanButtonContainer
    }
    
    
    private func makeBackButton() -> UIView {
        
        let backButton = BackButton()
        let backButtonContainer = UIView()
        
        backButtonContainer.frame = CGRect(x: 20, y: 44, width: 93, height: 55)
        backButtonContainer.backgroundColor = .clear
        backButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        backButtonContainer.clipsToBounds = true
        backButtonContainer.autoresizesSubviews = true
        
        self.view.addSubview(backButtonContainer)
        self.view.bringSubview(toFront: backButtonContainer)
        
        backButtonContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        backButtonContainer.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 44).isActive = true
        backButtonContainer.widthAnchor.constraint(equalToConstant: 93).isActive = true
        backButtonContainer.heightAnchor.constraint(equalToConstant: 55).isActive = true
        backButtonContainer.updateConstraints()
        
        backButton.frame = backButtonContainer.bounds
        backButton.addTarget(self, action: #selector(handleBackButtonTap), for: .touchUpInside)
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = backButtonContainer.bounds
        
        backButtonContainer.addSubview(blurredEffectView)
        blurredEffectView.contentView.addSubview(backButton)
        
        backButtonContainer.layer.cornerRadius = 15
        backButtonContainer.setNeedsLayout()
        
        return backButtonContainer
        
    }
    
    private func makeFlashlightButton() -> UIView {
        let _flashlightButton = FlashlightButton()
        let flashlightButtonContainer = UIView()
        
        flashlightButtonContainer.frame = CGRect(x: 20, y: self.view.frame.maxY - 112, width: 55, height: 55)
        flashlightButtonContainer.backgroundColor = .clear
        flashlightButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        flashlightButtonContainer.clipsToBounds = true
        flashlightButtonContainer.autoresizesSubviews = true
        
        self.view.addSubview(flashlightButtonContainer)
        self.view.bringSubview(toFront: flashlightButtonContainer)
        
        flashlightButtonContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        flashlightButtonContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -57).isActive = true
        flashlightButtonContainer.widthAnchor.constraint(equalToConstant: 55).isActive = true
        flashlightButtonContainer.heightAnchor.constraint(equalToConstant: 55).isActive = true
        flashlightButtonContainer.updateConstraints()
        
        _flashlightButton.frame = flashlightButtonContainer.bounds
        _flashlightButton.addTarget(self, action: #selector(handleFlashlightButtonTap), for: .touchUpInside)
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = flashlightButtonContainer.bounds
        
        flashlightButtonContainer.addSubview(blurredEffectView)
        blurredEffectView.contentView.addSubview(_flashlightButton)
        
        flashlightButtonContainer.layer.cornerRadius = flashlightButtonContainer.frame.width / 2
        flashlightButtonContainer.setNeedsLayout()
        
        self.flashLightButton = _flashlightButton
        return flashlightButtonContainer
        
    }
    
    private func makeInstructionLabelContainer() {
        
        self.instructionLabel = UILabel()
        self.instructionLabelContainer = UIView()
        
        instructionLabelContainer.frame = CGRect(x: self.view.frame.midX - 120, y: self.view.frame.midY - 18, width: 240, height: 36)
        instructionLabelContainer.backgroundColor = .clear
        instructionLabelContainer.translatesAutoresizingMaskIntoConstraints = false
        instructionLabelContainer.clipsToBounds = true
        instructionLabelContainer.autoresizesSubviews = true
        
        self.view.addSubview(instructionLabelContainer)
        self.view.bringSubview(toFront: instructionLabelContainer)
        
        instructionLabelContainer.widthAnchor.constraint(equalToConstant: 240).isActive = true
        instructionLabelContainer.heightAnchor.constraint(equalToConstant: 36).isActive = true
        instructionLabelContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        instructionLabelContainer.topAnchor.constraint(equalTo: self.focusView.bottomAnchor, constant: 20).isActive = true
        instructionLabelContainer.updateConstraints()
        
        instructionLabel.frame = instructionLabelContainer.bounds
        instructionLabel.font = UIFont(name: "ProximaNova-Semibold", size: 17)
        instructionLabel.textAlignment = .center
        instructionLabel.lineBreakMode = .byWordWrapping
        instructionLabel.text = "Place the barcode here."
        instructionLabel.textColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
        instructionLabel.backgroundColor = .clear
        instructionLabel.tintColor = .black
        
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = instructionLabelContainer.bounds
        instructionLabelContainer.addSubview(blurredEffectView)
        
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.frame = instructionLabelContainer.bounds
        
        vibrancyEffectView.contentView.addSubview(instructionLabel)
        blurredEffectView.contentView.addSubview(vibrancyEffectView)
        
        instructionLabelContainer.layer.cornerRadius = 8
        instructionLabelContainer.setNeedsLayout()
    }
    
    private func makeErrorLabelContainer() {
        
        self.errorLabel = UILabel()
        self.errorLabelContainer = UIView()
        
        errorLabelContainer.frame = CGRect(x: self.view.frame.midX - 130, y: self.view.frame.midY - 18, width: 260, height: 72)
        errorLabelContainer.backgroundColor = .clear
        errorLabelContainer.translatesAutoresizingMaskIntoConstraints = false
        errorLabelContainer.clipsToBounds = true
        errorLabelContainer.autoresizesSubviews = true
        
        self.view.addSubview(errorLabelContainer)
        self.view.bringSubview(toFront: errorLabelContainer)
        
        errorLabelContainer.widthAnchor.constraint(equalToConstant: 260).isActive = true
        errorLabelContainer.heightAnchor.constraint(equalToConstant: 72).isActive = true
        errorLabelContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        errorLabelContainer.topAnchor.constraint(equalTo: self.focusView.bottomAnchor, constant: 20).isActive = true
        errorLabelContainer.updateConstraints()
        
        errorLabel.frame = errorLabelContainer.bounds
        errorLabel.lineBreakMode = .byWordWrapping
        errorLabel.numberOfLines = 0
        errorLabel.font = UIFont(name: "ProximaNova-Semibold", size: 17)
        errorLabel.textAlignment = .center
        errorLabel.text = "We couldn't find information for this item."
        errorLabel.textColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
        errorLabel.backgroundColor = .clear
        errorLabel.tintColor = .black
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = errorLabelContainer.bounds
        errorLabelContainer.addSubview(blurredEffectView)
        
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.frame = errorLabelContainer.bounds
        
        vibrancyEffectView.contentView.addSubview(errorLabel)
        blurredEffectView.contentView.addSubview(vibrancyEffectView)
        
        errorLabelContainer.layer.cornerRadius = 8
        errorLabelContainer.alpha = 0
        errorLabelContainer.setNeedsLayout()
    }
    
    private func setUpCaptureSession() {
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        var videoInput: AVCaptureDeviceInput?
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput!)) {
            captureSession.addInput(videoInput!)
        } else {
            showScanningNotSupportedAlert()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417, .upce]
        } else {
            showScanningNotSupportedAlert()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = scanView.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        scanView.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
        
        // Important: this has to go here, i.e. after startRunning() is called.
        let rectToConvert = self.scanView.layer.convert(self.focusView.frame, from: self.view.layer)
        let rectOfInterest = previewLayer.metadataOutputRectConverted(fromLayerRect: rectToConvert)
        metadataOutput.rectOfInterest = rectOfInterest
        
    }
    
    private func setUpFocusView() {
        let focusViewFrame = CGRect(x: self.view.frame.midX - 120, y: self.view.frame.midY - 128, width: 240, height: 128)
        focusView = UIView(frame: focusViewFrame)
        focusView.layer.borderColor = UIColor.white.cgColor
        focusView.layer.borderWidth = 4
        focusView.backgroundColor = .clear
        focusView.layer.cornerRadius = 12
        focusView.layer.masksToBounds = false
        self.view.addSubview(focusView)
        focusView.isUserInteractionEnabled = false
        focusView.resignFirstResponder()
        focusView.setNeedsLayout()
    }
    
    private func setUpButtons() {
        self.backButton = makeBackButton()
        self.rescanButton = makeRescanButton()
        self.flashLightButtonContainer = makeFlashlightButton()
        
        instructionLabelContainer.layer.cornerRadius = 8
        
        self.slideOutRescanButton()
        
        let buttonDividerLine = CAShapeLayer()
        let frame = confirmationCardButtonContainer.bounds
        buttonDividerLine.frame = CGRect(x: frame.midX, y: frame.minY, width: 1, height: frame.height)
        buttonDividerLine.backgroundColor = UIColor.darkGray.cgColor
        buttonDividerLine.opacity = 0.1
        confirmationCardButtonContainer.layer.addSublayer(buttonDividerLine)
        
        let buttonsTopBorder = CAShapeLayer()
        buttonsTopBorder.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: 1)
        buttonsTopBorder.backgroundColor = UIColor.darkGray.cgColor
        buttonsTopBorder.opacity = 0.1
        confirmationCardButtonContainer.layer.addSublayer(buttonsTopBorder)
    }
    
    // MARK: - Failure Alerts
    private func showScanningNotSupportedAlert() {
        let alertController = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Okay", style: .default))
        
        present(alertController, animated: true)
        captureSession = nil
    }
    
    private func showConnectionFailureAlert() {
        let alertController = UIAlertController(title: "Problem establing a connection", message: "Looks like you might not be connected to the internet. To scan a barcode, make sure you have internet access and try again.", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Okay", style: .default))
        
        present(alertController, animated: true)
    }
    
    private func showBookInformationFailureAlert() {
        let alertController = UIAlertController(title: "Book Information Unavailable", message: "Looks like we couldn't find more information about this title.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .default))
        
        present(alertController, animated: true)
    }
    
    
    // MARK: - Interactions
    @objc private func handleBackButtonTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleRescanButtonTap() {
        self.scanningState = .scanning
    }
    
    @objc func handleFlashlightButtonTap() {
        self.flashLightButton.isOn = !self.flashlightIsOn
        self.flashlightIsOn = self.flashLightButton.isOn
        toggleFlashlight(on: self.flashlightIsOn)
    }
    
    @objc func handleScanViewTap(_ recognizer: UITapGestureRecognizer) {
        if self.scanningState == .success || self.scanningState == .error {
            self.scanningState = .scanning
        }
    }
    
    @objc func handlePrintButtonTap() {
        
        var result = [String: String]()
        
        result.updateValue(self.bookTitle, forKey: "title")
        result.updateValue(self.ISBN, forKey: "ISBN")
        
        self.dismiss(animated: true, completion: {
            self.delegate?.titleScannerDidReceiveResult(result: result, forSearchCategory: .print)
        })
    }
    
    @objc func handleDigitalButtonTap() {
        var result = [String: String]()
        
        result.updateValue(self.bookTitle, forKey: "title")
        result.updateValue(self.ISBN, forKey: "ISBN")
        
        self.dismiss(animated: true, completion: {
            self.delegate?.titleScannerDidReceiveResult(result: result, forSearchCategory: .digital)
        })
    }
    
    // MARK: - Update UI
    private func updateUIForState() {
        switch self.scanningState {
            
        case .scanning:
            self.flashLightButton.isUserInteractionEnabled = true
            self.bookTitle = ""
            self.ISBN = ""
            self.bookInformationURL = nil
            let options: UIView.AnimationOptions = [
                .repeat,
                .autoreverse,
                .beginFromCurrentState,
                .preferredFramesPerSecond60
            ]
            self.animateFocusView(withDuration: 1.5, andOptions: options) {
                self.focusView.layer.borderColor = UIColor.white.cgColor
                self.focusView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
            self.updateInstructionLabel()
            self.updateErrorLabel()
            self.slideOutRescanButton()
            
            self.removeProcessingAnimation()
            
            if self.confirmationCardIsVisible {
                self.slideOutConfirmationCard()
            } else {
                self.shouldProceedWithScanning = true
            }
            
        case .recognized:
            self.shouldProceedWithScanning = false
            
            let options: UIView.AnimationOptions = [
                .beginFromCurrentState,
                .preferredFramesPerSecond60
            ]
            
            self.animateFocusView(withDuration: 0.5, andOptions: options) {
                self.focusView.layer.borderColor = UIColor.green.cgColor
                self.focusView.transform = .identity
            }
            self.showProcessingAnimation()
            self.updateInstructionLabel()
            
            
        case .success:
            self.removeProcessingAnimation()
            self.animateFocusView(withDuration: 0.5, andOptions: []) {
                self.focusView.layer.borderColor = UIColor.clear.cgColor
            }
            self.flashLightButton.isUserInteractionEnabled = false
            self.slideInConfirmationCard()
            self.slideInRescanButton()
            
        case .error:
            self.animateFocusView(withDuration: 0.5) { [weak self] in
                //self?.focusView.transform = .identity
                self?.focusView.layer.borderColor = UIColor.red.cgColor
            }
            self.removeProcessingAnimation()
            self.updateInstructionLabel()
            self.updateErrorLabel()
            self.slideInRescanButton()
        
        }
    }
    
    private func toggleFlashlight(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                
                if on == true {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }
                
                device.unlockForConfiguration()
            } catch {
                print("Flashlight could not be used.")
            }
        } else {
            print("Flashlight is not available.")
        }
    }
    
    private func updateErrorLabel() {
        
        var alpha: CGFloat = 0.0
        
        switch self.scanningState {
        case .error:
            alpha = 1.0
        case .scanning:
            alpha = 0.0
        default:
            return
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.errorLabelContainer.alpha = alpha
        })
        
    }
    
    private func updateInstructionLabel () {
        switch self.scanningState {
        case .scanning:
            animateInstructionLabel { [weak self] in
                self?.instructionLabelContainer.alpha = 1
            }
            
        case .recognized:
            animateInstructionLabel { [weak self] in
                self?.instructionLabelContainer.alpha = 0
            }
            
        case .success:
            animateInstructionLabel { [weak self] in
                self?.instructionLabelContainer.alpha = 0
            }
            self.removeProcessingAnimation()
            
        case .error:
            self.animateInstructionLabel { [weak self] in
                self?.instructionLabelContainer.alpha = 0
            }
        }
    }
    
    private func slideInRescanButton() {
        UIView.animate(withDuration: 0.45, animations: {
            self.rescanButton.alpha = 1
            self.rescanButton.transform = .identity
        })
    }
    
    private func slideOutRescanButton() {
        let distance = self.view.bounds.maxX - self.rescanButton.frame.minX
        
        UIView.animate(withDuration: 0.35, animations: {
            self.rescanButton.transform = CGAffineTransform(translationX: distance, y: 0)
        })
    }
    
    // Instruction Label Animations
    private func animateInstructionLabel(byCalling closure: @escaping ()->() ) {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.beginFromCurrentState, .preferredFramesPerSecond60], animations: {
            closure()
        }, completion: nil)
    }
    
    // Focus View animations
    private func animateFocusView(withDuration duration: TimeInterval, andOptions options: UIView.AnimationOptions = [], andCompletion completion: @escaping () -> () = {}, andByCalling closure: @escaping () -> () ) {
        
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            closure()
            
        }, completion: {_ in
            completion()
        })
    }
    
    private func showProcessingAnimation() {
        let barcodeViewFrame = CGRect(x: self.focusView.bounds.midX - 11, y: self.focusView.bounds.midY - 11, width: 22, height: 22)
        self.barcodeView = AnimatableBarcodeView(frame: barcodeViewFrame)
        // self.barcodeView.delegate = self
        //self.barcodeView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        self.focusView.addSubview(barcodeView)
        
        barcodeView.startAnimation()
    }
    
    private func removeProcessingAnimation() {
        self.barcodeView.stopAnimation()
    }
    
    
    // Confirmation Card Actions
    // Slide Out
    private func slideOutConfirmationCard() {
        let distance = self.view.frame.maxY - confirmationCard.frame.minY + 20
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {
            self.confirmationCard.transform = CGAffineTransform(translationX: 0, y: distance)
            self.instructionLabelContainer.alpha = 1
            
        }, completion: {_ in
            self.bookTitleLabel.text = ""
            self.authorNameLabel.text = ""
            self.confirmationCardImage.image = nil
            self.confirmationCard.updateConstraints()
            self.confirmationCardIsVisible = false
            self.shouldProceedWithScanning = true
        })
    }
    
    // Slide In
    private func slideInConfirmationCard() {
    
        self.confirmationCardImageContainer.layer.shadowPath = UIBezierPath(rect: confirmationCardImage.frame).cgPath
        self.confirmationCardImageContainer.layer.shadowColor = UIColor.black.cgColor
        self.confirmationCardImageContainer.layer.shadowOpacity = 0.6
        self.confirmationCardImageContainer.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.confirmationCardImageContainer.layer.shadowRadius = 10
        
        self.confirmationCardImage.layer.cornerRadius = 2
       
        self.confirmationCard.setNeedsDisplay()
        
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {
            self.confirmationCard.transform = .identity
            
        }, completion: { _ in
            self.confirmationCardIsVisible = true
        })
    }
}


// MARK: - Capture MetaData Delegate
extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    enum FetchingError: Error  {
        case noData
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if shouldProceedWithScanning  {
            
            // 1. Check whether we received any metadata
            if metadataObjects.count == 0 {
                print("No input detected.")
                return
            }
            
            // 2. Extract metadataObject
            if let metadataObject = metadataObjects.first {
                
                // 3. Extract barcode number (string) from metadataObject and check that it matches one of the types we're looking for
                guard
                    let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
                    var barcode = readableObject.stringValue
                    else { return }
                
                // 4. Parse UPC-A if and when we receive a number of that type and update the barcode variable
                var rawType = readableObject.type.rawValue
                
                // UPC-A is an EAN-13 barcode with a zero prefix.
                if readableObject.type == AVMetadataObject.ObjectType.ean13 && barcode.hasPrefix("0") {
                    barcode = String(barcode.dropFirst())
                    rawType = AVMetadataObject.ObjectType.upca.rawValue
                }
                
                print("Barcode Data: \(barcode)")
                print("Symbology Type: \(rawType)")
                
                // 5. Start progress / recognition-success animation and pause scanning
                self.scanningState = .recognized
                
                // 6. Store ISBN
                self.ISBN = barcode
                
                // 7. Make the API call, passing in the barcode number we extracted.
                self.getGoogleBooksData(for: barcode)
            }
        }
    }
    
}
// MARK: - Data Handling
private extension ScannerViewController {
    
    func getGoogleBooksData(for UPCString: String) {
        
        var barcodeString = UPCString
        
        self.shouldUseTestData = UserDefaults.standard.bool(forKey: "shouldUseTestData")
        if shouldUseTestData {
            print("Using test data.")
            barcodeString = "9780465050659"
        }
        
        if let apiKeyFile = Bundle.main.path(forResource: "APIKey", ofType: "txt") {
            do {
                let apiKey = try String(contentsOfFile: apiKeyFile, encoding: String.Encoding.utf8)
                self.googleBooksAPIKey = apiKey
                
            } catch {
                print(error)
            }
        }
        
        guard let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=isbn:\(barcodeString)&key=\(self.googleBooksAPIKey)") else {
            self.showConnectionFailureAlert()
            self.scanningState = .scanning
            return
        }
        
            self.ISBN = barcodeString
            
            let task = URLSession.shared.bookFallBackTask(with: url) { book, response, error in
                
                guard error == nil else {
                    self.scanningState = .error
                    return
                }
                
                if let book = book {
                    
                    let volumeInfo = book.items[0].volumeInfo
                    
                    let bookTitle = volumeInfo.title
                    self.bookTitle = bookTitle
                    
                    if let bookSubtitle = volumeInfo.subtitle {
                        DispatchQueue.main.async {
                            self.bookTitleLabel.text = "\(bookTitle): \(bookSubtitle)"
                        }
                        
                    } else {
                        DispatchQueue.main.async {
                            self.bookTitleLabel.text = bookTitle
                        }
                    }
                    
                    let authors = volumeInfo.authors
                    var authorNames = ""
                    
                    if !authors.isEmpty {
                        
                        if authors.count > 1 { // For book with more than one author
                            
                            for author in authors {
                                var authorNameWithPunctuation = ""
                                
                                if author == authors.last {
                                    authorNameWithPunctuation = "\(author)"
                                } else {
                                    authorNameWithPunctuation = "\(author), "
                                }
                                
                                authorNames += authorNameWithPunctuation
                            }
                            
                        } else { // For book with only one author
                            authorNames = authors[0]
                        }
                        
                    }
                    DispatchQueue.main.async {
                        self.authorNameLabel.text = authorNames
                    }
                    
                    if var bookCoverImageURLString = volumeInfo.imageLinks?.smallThumbnail {
                    
                        if let rangeOfHTPP = bookCoverImageURLString.range(of: "http://") {
                            bookCoverImageURLString.replaceSubrange(rangeOfHTPP, with: "https://")
                        }
                        
                        
                        if let bookCoverImageURL = URL(string: bookCoverImageURLString) {
                        
                            let downloadBookCoverImageTask = URLSession.shared.dataTask(with: bookCoverImageURL) { data, response, error in
                             
                                if error == nil {
                                    
                                    if let data = data, let _ = response {
                                        
                                        let bookCoverImage = UIImage(data: data)
                                        DispatchQueue.main.async {
                                            self.confirmationCardImage.image = bookCoverImage
                                            self.scanningState = .success
                                        }
                                    }
                                    
                                } else {
                                    print("Couldn't fetch thumbnail image. Response: \(String(describing: response))")
                                }
                                
                            }
                            downloadBookCoverImageTask.resume()
                            
                        }
                    }
                    
                    self.bookInformationURL = URL(string: book.items[0].volumeInfo.infoLink)
                    
                } else {
                    self.scanningState = .error
                }
            }
            task.resume()
    }
}



