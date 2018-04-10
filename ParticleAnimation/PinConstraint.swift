//
//  PinConstraint.swift
//  ParticleAnimation
//
//  Created by Mellong on 02/03/2018.
//  Copyright © 2018 Long. All rights reserved.
//

import UIKit

public class PinConstraint: Constraint, Entity {
    public var a: Particle
    public var pos: Vec2
    
    public init(a: Particle, pos: Vec2) {
        self.a = a
        self.pos = pos
    }

    public func relax(stepCoef: Float) {
        _ = a.pos.mutableSet(v: pos)
    }
    
    public func draw(ctx: CGContext) {
        ctx.setFillColor(UIColor(red: 0.0, green: 153.0/255.0, blue: 1.0, alpha: 0.1).cgColor)
        ctx.addArc(center: pos.toCGPoint(), radius: 6, startAngle: 0.0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
        ctx.fillPath()
    }
}
