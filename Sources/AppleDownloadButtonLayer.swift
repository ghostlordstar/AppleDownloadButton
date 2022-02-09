//
//  AppleDownloadButtonLayer.swift
//  AppleDownloadButton
//
//  Created by Hansen on 2022/2/9.                    
//

import UIKit
class AppleDownloadButtonLayer: CALayer {
    
    // MARK: - Properties
    @NSManaged var toDownloadManipulable: CGFloat
    @NSManaged var rippleManipulable: CGFloat
    @NSManaged var dashMoveManipulable: CGFloat
    @NSManaged var readyToDownloadManipulable: CGFloat
    @NSManaged var downloadedManipulable: CGFloat
    @NSManaged var checkRevealManipulable: CGFloat
    
    // MARK: - Initializers
    override init() {
        super.init()
        
        toDownloadManipulable = 0.0
        rippleManipulable = 0.0
        dashMoveManipulable = 0.0
        readyToDownloadManipulable = 0.0
        downloadedManipulable = 0.0
        checkRevealManipulable = 0.0
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        if let layer = layer as? AppleDownloadButtonLayer {
            toDownloadManipulable = layer.toDownloadManipulable
            rippleManipulable = layer.rippleManipulable
            dashMoveManipulable = layer.dashMoveManipulable
            readyToDownloadManipulable = layer.readyToDownloadManipulable
            downloadedManipulable = layer.downloadedManipulable
            checkRevealManipulable = layer.checkRevealManipulable
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Lifecyle
    override class func needsDisplay(forKey key: String?) -> Bool {
        guard let key = key else { return false }
        if AppleDownloadButtonLayer.isCompatible(key) {
            return true
        }
        return super.needsDisplay(forKey: key)
    }
    
    override func action(forKey event: String?) -> CAAction? {
        guard let event = event else { return nil }
        if AppleDownloadButtonLayer.isCompatible(event) {
            let animation = CABasicAnimation.init(keyPath: event)
            animation.fromValue = presentation()?.value(forKey: event)
            return animation
        }
        return super.action(forKey: event)
    }
    
    // MARK: - Functions
    private static func isCompatible(_ key: String) -> Bool {
        return key == "toDownloadManipulable" ||
        key == "rippleManipulable" ||
        key == "dashMoveManipulable" ||
        key == "readyToDownloadManipulable" ||
        key == "downloadedManipulable" ||
        key == "checkRevealManipulable"
    }
}
