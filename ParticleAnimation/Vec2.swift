//
//  ds.swift
//  ParticleAnimation
//
//  Created by Mellong on 02/03/2018.
//  Copyright © 2018 Long. All rights reserved.
//

import Foundation
import UIKit

public struct Vec2 {
    public var x: Float
    public var y: Float
    
    public init(x: Float = 0.0, y: Float = 0.0) {
        self.x = x
        self.y = y
    }
    
    public func add(v: Vec2) -> Vec2 {
        return Vec2(x: x + v.x, y: y + v.y)
    }
    
    public func sub(v: Vec2) -> Vec2 {
        return Vec2(x: x - v.x, y: y - v.y)
    }
    
    public func mul(v: Vec2) -> Vec2 {
        return Vec2(x: x * v.x, y: y * v.y)
    }
    
    public func div(v: Vec2) -> Vec2 {
        return Vec2(x: x / v.x, y: y / v.y)
    }
    
    public func scale(coef: Float) -> Vec2 {
        return Vec2(x: x * coef, y: y * coef)
    }
    
    public mutating func mutableSet(v: Vec2) -> Vec2 {
        x = v.x
        y = v.y
        return self
    }
    
    public mutating func mutableAdd(v: Vec2) -> Vec2 {
        x += v.x
        y += v.y
        return self
    }
    
    public mutating func mutableSub(v: Vec2) -> Vec2 {
        x -= v.x
        y -= v.y
        return self
    }
    
    public mutating func mutableMul(v: Vec2) -> Vec2 {
        x *= v.x
        y *= v.y
        return self
    }
    
    public mutating func mutableDiv(v: Vec2) -> Vec2 {
        x /= v.x
        y /= v.y
        return self
    }
    
    public mutating func mutableScale(coef: Float) -> Vec2 {
        x *= coef
        y *= coef
        return self
    }
    
    public func equals(v: Vec2) -> Bool {
        return x == v.x && y == v.y
    }
    
    public func epsilonEquals(v: Vec2, epsilon: Float) -> Bool {
        return abs(x - v.x) <= epsilon && abs(y - v.y) <= epsilon
    }
    
    public func length() -> Float {
        return sqrt(length2())
    }
    
    public func length2() -> Float {
        return x * x + y * y
    }
    
    public func dist(v: Vec2) -> Float {
        return sqrt(dist2(v: v))
    }
    
    public func dist2(v: Vec2) -> Float {
        let x1 = v.x - x
        let y1 = v.y - y
        return x1 * x1 + y1 * y1
    }
    
    public func normal() -> Vec2 {
        let m = sqrt(x * x + y * y)
        return Vec2(x: x / m, y: y / m);
    }
    
    mutating func normalize() {
        let m = mag()
        if m != 0 {
            mult(1 / m)
        }
    }
    
    mutating func mult(_ n: Float) {
        x *= n
        y *= n
    }
    
    public func dot(v: Vec2) -> Float {
        return x * v.x + y * v.y
    }
    
    public func angle(v: Vec2) -> Float {
        return atan2(x * v.y - y * v.x, x * v.x + y * v.y)
    }
    
    public func angle2(vLeft: Vec2, vRight: Vec2) -> Float {
        return vLeft.sub(v: self).angle(v: vRight.sub(v: self))
    }
    
    public func rotate(origin: Vec2, theta: Float) -> Vec2 {
        let x1 = x - origin.x;
        let y1 = y - origin.y;
        return Vec2(x: x1 * cos(theta) - y1 * sin(theta) + origin.x, y: x1 * sin(theta) + y1 * cos(theta) + origin.y)
    }
    
    func mag() -> Float {
        return sqrt(x * x + y * y)
    }
    
    public func toString() -> String {
        return "(\(x), \(y))";
    }
    
    public func toCGPoint() -> CGPoint {
        return CGPoint(x: CGFloat(x), y: CGFloat(y))
    }
}

