//
//  AngleConstraint.swift
//  ParticleAnimation
//
//  Created by Mellong on 02/03/2018.
//  Copyright © 2018 Long. All rights reserved.
//

import UIKit

public class AngleConstraint: Constraint {
    var a: Particle
    var b: Particle
    var c: Particle
    var angle: Float
    var stiffness: Float
    
    public init(a: Particle, b: Particle, c: Particle, stiffness: Float) {
        self.a = a
        self.b = b
        self.c = c
        self.angle = self.b.pos.angle2(vLeft: self.a.pos, vRight: self.c.pos)
        self.stiffness = stiffness
    }
    
    public func relax(stepCoef: Float) {
        let bAngle = b.pos.angle2(vLeft: a.pos, vRight: c.pos)
        var diff = bAngle - angle
        
        if (diff <= -Float.pi) {
            diff += Float(2 * Double.pi)
        }else if (diff >= Float.pi) {
            diff -= Float(2 * Double.pi)
        }
        
        diff *= stepCoef * stiffness
        
        a.pos = a.pos.rotate(origin: b.pos, theta: diff)
        c.pos = c.pos.rotate(origin: b.pos, theta: -diff)
        b.pos = b.pos.rotate(origin: a.pos, theta: diff)
        b.pos = b.pos.rotate(origin: c.pos, theta: -diff)
    }
    
    public func draw(ctx: CGContext) {
        ctx.saveGState()
        ctx.setStrokeColor(UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 0.2).cgColor)
        ctx.setLineWidth(5.0)
        ctx.move(to: a.pos.toCGPoint())
        ctx.addLine(to: b.pos.toCGPoint())
        ctx.addLine(to: c.pos.toCGPoint())
        ctx.strokePath()
        ctx.restoreGState()
    }
}
