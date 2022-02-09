//
//  AppleDownloadButton.swift
//  AppleDownloadButton
//
//  Created by Leonardo Cardoso on 20/05/2017.
//  Copyright © 2017 leocardz.com. All rights reserved.
//

import Foundation
import UIKit

public enum AppleDownloadButtonStyle: String {
    case iOS = "iOS", macOS = "macOS", watchOS = "watchOS", tvOS = "tvOS"
}

public enum AppleDownloadButtonState: String {
    case toDownload = "toDownload", willDownload = "willDownload", readyToDownload = "readyToDownload", downloaded = "downloaded"
}

public protocol AppleDownloadButtonDelegate {
    func stateChanged(button: AppleDownloadButton, newState: AppleDownloadButtonState)
}

@IBDesignable
open class AppleDownloadButton: UIButton {
    
    // MARK: - IBDesignable and IBInspectable
    @IBInspectable open var isDownloaded: Bool = false {
        willSet {
            if newValue {
                animate(keyPath: "downloadedManipulable")
                animate(keyPath: "checkRevealManipulable")
            }
        }
    }
    
    @IBInspectable open var buttonBackgroundColor: UIColor? {
        didSet {
            palette.buttonBackgroundColor = buttonBackgroundColor ?? palette.buttonBackgroundColor
        }
    }
    
    @IBInspectable open var initialColor: UIColor? {
        didSet {
            palette.initialColor = initialColor ?? palette.initialColor
        }
    }
    
    @IBInspectable open var rippleColor: UIColor? {
        didSet {
            palette.rippleColor = rippleColor ?? palette.rippleColor
        }
    }
    
    @IBInspectable open var downloadColor: UIColor? {
        didSet {
            palette.downloadColor = downloadColor ?? palette.downloadColor
        }
    }
    
    @IBInspectable open var deviceColor: UIColor? {
        didSet {
            palette.deviceColor = deviceColor ?? palette.deviceColor
        }
    }
    
    @IBInspectable open var style: String = AppleDownloadButtonStyle.iOS.rawValue {
        didSet {
            if style == AppleDownloadButtonStyle.macOS.rawValue {
                self.buttonStyle = .macOS
            } else if style == AppleDownloadButtonStyle.tvOS.rawValue {
                self.buttonStyle = .tvOS
            } else if style == AppleDownloadButtonStyle.watchOS.rawValue {
                self.buttonStyle = .watchOS
            } else {
                self.buttonStyle = .iOS
            }
        }
    }
    
    override open class var layerClass: AnyClass {
        return AppleDownloadButtonLayer.self
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        draw()
    }
    
    public init(frame: CGRect, isDownloaded: Bool = false, style: AppleDownloadButtonStyle = .iOS, palette: Palette = Palette()) {
        super.init(frame: frame)
        self.isDownloaded = isDownloaded
        self.buttonStyle = style
        self.palette = palette
        draw()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Lifecyle
    override open func awakeFromNib() {
        draw()
    }
    
    
    // MARK: - Properties
    var keyPath: String = "toDownloadManipulable"
    open var palette: Palette = Palette()
    open var delegate: AppleDownloadButtonDelegate?
    open var downloadPercent: CGFloat = 0.0 {
        willSet {
            guard let layer: AppleDownloadButtonLayer = layer as? AppleDownloadButtonLayer else { return }
            if newValue >= 1.0 {
                Flow.delay(for: 0.5) {
                    self.downloadState = .downloaded
                    layer.readyToDownloadManipulable = 0.0
                }
            }
            animate(duration: 0.5, from: layer.readyToDownloadManipulable, to: newValue, keyPath: "readyToDownloadManipulable")
        }
    }
    
    private var buttonStyle: AppleDownloadButtonStyle?
    
    open var downloadState: AppleDownloadButtonState? {
        willSet {
            guard let newValue: AppleDownloadButtonState = newValue else { return }
            if !isDownloaded {
                switch newValue {
                case .toDownload:
                    resetManipulables()
                    Flow.async {
                        self.animate(keyPath: "toDownloadManipulable")
                    }
                    return
                case .willDownload:
                    Flow.async {
                        self.animate(duration: 1, keyPath: "rippleManipulable")
                    }
                    return
                case .readyToDownload:
                    Flow.async {
                        self.animate(to: 0, keyPath: "readyToDownloadManipulable")
                    }
                    return
                case .downloaded:
                    Flow.async {
                        self.animate(duration: 1, keyPath: "downloadedManipulable")
                    }
                    return
                }
            }
        }
    }
    
    override open func draw(_ layer: CALayer, in ctx: CGContext) {
        super.draw(layer, in: ctx)
        guard
            let layer: AppleDownloadButtonLayer = layer as? AppleDownloadButtonLayer,
            let buttonStyle: AppleDownloadButtonStyle = buttonStyle
        else { return }
        
        let frame = CGRect(origin: CGPoint(x: 0, y: 0), size: layer.frame.size)
        UIGraphicsPushContext(ctx)
        switch keyPath {
        case "toDownloadManipulable":
            StyleKit.drawToDownloadState(frame: frame, palette: palette, toDownloadManipulable: layer.toDownloadManipulable)
            break
        case "rippleManipulable":
            StyleKit.drawRippleState(frame: frame, palette: palette, rippleManipulable: layer.rippleManipulable)
            break
        case "dashMoveManipulable":
            StyleKit.drawDashMoveState(frame: frame, palette: palette, dashMoveManipulable: layer.dashMoveManipulable)
            break
        case "readyToDownloadManipulable":
            StyleKit.drawReadyToDownloadState(frame: frame, palette: palette, readyToDownloadManipulable: layer.readyToDownloadManipulable)
            break
        case "downloadedManipulable":
            StyleKit.drawDownloadCompleteState(frame: frame, palette: palette, style: buttonStyle, downloadedManipulable: layer.downloadedManipulable)
            break
        case "checkRevealManipulable":
            StyleKit.drawCheckState(frame: frame, palette: palette, style: buttonStyle, checkRevealManipulable: layer.checkRevealManipulable)
            break
        default:
            break
        }
        UIGraphicsPopContext()
    }
    
    // MARK: - Functions
    private func resetManipulables() {
        guard let layer: AppleDownloadButtonLayer = layer as? AppleDownloadButtonLayer else { return }
        layer.toDownloadManipulable = 0.0
        layer.rippleManipulable = 0.0
        layer.dashMoveManipulable = 0.0
        layer.readyToDownloadManipulable = 0.0
        layer.downloadedManipulable = 0.0
        layer.checkRevealManipulable = 0.0
    }
    
    func draw() {
        downloadState = downloadState ?? .toDownload
        buttonStyle = buttonStyle ?? .iOS
        needsDisplay()
    }
    
    func needsDisplay() {
        layer.contentsScale = UIScreen.main.scale
        layer.setNeedsDisplay()
    }
    
    fileprivate func animate(duration: TimeInterval = 0, delay: TimeInterval = 0, from: CGFloat = 0, to: CGFloat = 1, keyPath: String) -> Void {
        guard let layer: AppleDownloadButtonLayer = layer as? AppleDownloadButtonLayer else { return }
        self.keyPath = keyPath
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.beginTime = CACurrentMediaTime() + delay
        animation.duration = duration
        animation.fillMode = CAMediaTimingFillMode.both
        animation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeOut)
        animation.fromValue = from
        animation.toValue = to
        animation.delegate = self
        layer.add(animation, forKey: nil)
        Flow.async {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            self.updateManipulable(layer, keyPath, to)
            CATransaction.commit()
        }
    }
    
    private func updateManipulable(_ layer: AppleDownloadButtonLayer, _ keyPath: String, _ value: CGFloat) {
        switch keyPath {
        case "toDownloadManipulable":
            layer.toDownloadManipulable = value
            return
        case "rippleManipulable":
            layer.rippleManipulable = value
            return
        case "dashMoveManipulable":
            layer.dashMoveManipulable = value
            return
        case "readyToDownloadManipulable":
            layer.readyToDownloadManipulable = value
            return
        case "downloadedManipulable":
            layer.downloadedManipulable = value
            return
        case "checkRevealManipulable":
            layer.checkRevealManipulable = value
            return
        default:
            return
        }
    }
}

extension AppleDownloadButton: CAAnimationDelegate {
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let keyPath = (anim as? CABasicAnimation)?.keyPath else { return }
        if keyPath == "rippleManipulable" {
            animate(duration: 1, keyPath: "dashMoveManipulable")
        } else if keyPath == "downloadedManipulable" {
            if !isDownloaded {
                animate(duration: 0.5, keyPath: "checkRevealManipulable")
            }
        }
        
        if keyPath == "toDownloadManipulable" {
            delegate?.stateChanged(button: self, newState: .toDownload)
        } else if keyPath == "rippleManipulable" {
            delegate?.stateChanged(button: self, newState: .willDownload)
        } else if keyPath == "dashMoveManipulable" {
            delegate?.stateChanged(button: self, newState: .readyToDownload)
        } else if keyPath == "checkRevealManipulable" {
            delegate?.stateChanged(button: self, newState: .downloaded)
        }
    }
}
