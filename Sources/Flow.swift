//
//  Flow.swift
//  AppleDownloadButton
//
//  Created by Hansen on 2022/2/9.
//

import Foundation

internal class Flow {

    // MARK: - Functions
    // Execute code block asynchronously
    static func async(block: @escaping () -> Void) {
        DispatchQueue.main.async(execute: block)
    }

    // Execute code block asynchronously after given delay time
    static func delay(for delay: TimeInterval, block: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: block)
    }
}
