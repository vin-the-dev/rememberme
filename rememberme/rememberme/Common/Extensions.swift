//
//  Extensions.swift
//  rememberme
//
//  Created by Vineeth Vijayan on 25/08/16.
//  Copyright © 2016 Vineeth Vijayan. All rights reserved.
//

import Foundation
import UIKit

public extension Int32 {
    /// SwiftRandom extension
    public static func random(range: Range<Int>) -> Int32 {
        return random(lower: range.lowerBound, range.upperBound)
    }
    
    /// SwiftRandom extension
    ///
    /// - note: Using `Int` as parameter type as we usually just want to write `Int32.random(13, 37)` and not `Int32.random(Int32(13), Int32(37))`
    public static func random(lower: Int = 0, _ upper: Int = 100) -> Int32 {
        let r = arc4random_uniform(UInt32(Int64(upper) - Int64(lower)))
        return Int32(Int64(r) + Int64(lower))
    }
}

public extension UIColor {
    public convenience init?(hexString: String, alpha: CGFloat = 1.0) {
        var formatted = hexString.replacingOccurrences(of: "0x", with: "")
     
        formatted = formatted.replacingOccurrences(of: "#", with: "")
        if let hex = Int(formatted, radix: 16) {
            let red = CGFloat(CGFloat((hex & 0xFF0000) >> 16)/255.0)
            let green = CGFloat(CGFloat((hex & 0x00FF00) >> 8)/255.0)
            let blue = CGFloat(CGFloat((hex & 0x0000FF) >> 0)/255.0)
            self.init(red: red, green: green, blue: blue, alpha: alpha)        } else {
            return nil
        }
    }
}

extension Bool {
    
    public mutating func toggle() -> Bool {
        self = !self
        return self
    }
}
