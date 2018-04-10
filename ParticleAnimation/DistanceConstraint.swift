//
//  DistanceConstraint.swift
//  ParticleAnimation
//
//  Created by Mellong on 02/03/2018.
//  Copyright © 2018 Long. All rights reserved.
//

import UIKit


// DistanceConstraint -- constrains to initial distance
// PinConstraint -- constrains to static/fixed point
// AngleConstraint -- constrains 3 particles to an angle

public class DistanceConstraint: Constraint {
    public var a: Particle
    public var b: Particle
    public var stiffness: Float
    public var distance: Float
    
    public init(a: Particle, b: Particle, stiffness: Float, distance: Float? = nil) {
        self.a = a
        self.b = b
        self.stiffness = stiffness
        self.distance = distance ?? a.pos.sub(v: b.pos).length()
    }
    
    public func relax(stepCoef: Float) {
        var normal = a.pos.sub(v: b.pos)
        let m = normal.length2()
        _ = normal.mutableScale(coef: ((distance * distance - m)/m) * stiffness * stepCoef)
        _ = a.pos.mutableAdd(v: normal)
        _ = b.pos.mutableSub(v: normal)
    }
    
    public func draw(ctx: CGContext) {
        ctx.setStrokeColor(UIColor(hex: "#d8dde2").cgColor)
        ctx.move(to: a.pos.toCGPoint())
        ctx.addLine(to: b.pos.toCGPoint())
        ctx.strokePath()
    }
}
