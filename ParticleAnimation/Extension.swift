//
//  Extension.swift
//  ParticleAnimation
//
//  Created by Mellong on 02/03/2018.
//  Copyright © 2018 Long. All rights reserved.
//


import UIKit

extension Int {
    var float: Float {
        return Float(self)
    }
}

extension Double {
    var float: Float {
        return Float(self)
    }
    
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
}


extension CGFloat {
    var float: Float {
        return Float(self)
    }
}

extension Float {
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
    
    var double: Double {
        return Double(self)
    }
}

extension UIView {
    var width: CGFloat {
        return self.bounds.size.width
    }
    var height: CGFloat {
        return self.bounds.size.height
    }
    var x: CGFloat {
        return self.frame.origin.x
    }
    var y: CGFloat {
        return self.frame.origin.y
    }
}

extension UIColor {
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) { cString.removeFirst() }
        
        if ((cString.count) != 6) {
            self.init(hex: "ff0000") // return red color for wrong hex input
            return
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    
}

class Random {
    
    subscript<T>(_ min: T, _ max: T) -> T where T : BinaryInteger {
        get {
            return rand(min-1, max+1)
        }
    }
}

let rand = Random()

func rand<T>(_ min: T, _ max: T) -> T where T : BinaryInteger {
    let _min = min + 1
    let difference = max - _min
    return T(arc4random_uniform(UInt32(difference))) + _min
}

extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}
