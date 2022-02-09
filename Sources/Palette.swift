//
//  Palette.swift
//  AppleDownloadButton
//
//  Created by Hansen on 2022/2/9.                    
//

import Foundation

open class Palette {
    
    var initialColor: UIColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
    var rippleColor: UIColor = UIColor(red: 0.572, green: 0.572, blue: 0.572, alpha: 1.000)
    var buttonBackgroundColor: UIColor = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 1.000)
    var downloadColor: UIColor = UIColor(red: 0.145, green: 0.439, blue: 0.733, alpha: 1.000)
    var deviceColor: UIColor = UIColor(red: 0.145, green: 0.439, blue: 0.733, alpha: 1.000)

    public init(initialColor: UIColor? = nil, rippleColor: UIColor? = nil, buttonBackgroundColor: UIColor? = nil, downloadColor: UIColor? = nil, deviceColor: UIColor? = nil) {
        self.initialColor = initialColor ?? self.initialColor
        self.rippleColor = rippleColor ?? self.rippleColor
        self.buttonBackgroundColor = buttonBackgroundColor ?? self.buttonBackgroundColor
        self.downloadColor = downloadColor ?? self.downloadColor
        self.deviceColor = deviceColor ?? self.deviceColor
    }
}
