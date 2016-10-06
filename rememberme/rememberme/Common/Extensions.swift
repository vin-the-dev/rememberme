//
//  Extensions.swift
//  rememberme
//
//  Created by Vineeth Vijayan on 25/08/16.
//  Copyright © 2016 Vineeth Vijayan. All rights reserved.
//

import Foundation
import UIKit

public extension Int {
    /// SwiftRandom extension
    public static func random(range: Range<Int>) -> Int {
        return random(lower: range.lowerBound, range.upperBound)
    }
    
    /// SwiftRandom extension
    public static func random(lower: Int = 0, _ upper: Int = 100) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
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

extension UILabel {
    public func setText(_ text: String?, animated: Bool, duration: TimeInterval?) {
        if animated {
            UIView.transition(with: self, duration: duration ?? 0.3, options: .transitionCrossDissolve, animations: { () -> Void in
                self.text = text
                }, completion: nil)
        } else {
            self.text = text
        }
        
    }
}

extension UIImageView {
    public func setImage(_ image: UIImage?, animated: Bool, duration: TimeInterval?) {
        if animated {
            UIView.transition(with: self, duration: duration ?? 0.3, options: .transitionCrossDissolve, animations: { () -> Void in
                self.image = image
                }, completion: nil)
        } else {
            self.image = image
        }
        
    }
}


