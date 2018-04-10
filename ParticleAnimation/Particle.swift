//
//  Particle.swift
//  ParticleAnimation
//
//  Created by Mellong on 02/03/2018.
//  Copyright © 2018 Long. All rights reserved.
//

import Foundation
import UIKit

public class Particle: Entity, Equatable {
    public var pos: Vec2
    public var lastPos: Vec2
    
    public init(_ pos: Vec2) {
        self.pos = pos
        self.lastPos = pos
    }
    
    public func draw(ctx: CGContext) {
        ctx.setFillColor(UIColor(hex: "2dad8f").cgColor)
        ctx.addArc(center: pos.toCGPoint(), radius: 2.0, startAngle: 0.0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
        ctx.fillPath()
    }
    
    public static func ==(lhs: Particle, rhs: Particle) -> Bool {
        return lhs.pos.equals(v: rhs.pos) && lhs.lastPos.equals(v: rhs.lastPos)
    }
}

public class Composite {
    var particles = [Particle]()
    var constraints = [Constraint]()
    var drawParticles: ((CGContext, Composite) -> Void)?
    var drawConstraints: ((CGContext, Composite) -> Void)?
    
    public func pin(index: Int, pos: Vec2? = nil) -> PinConstraint {
        let position = pos ?? particles[index].pos
        let pc = PinConstraint(a: particles[index], pos: position)
        constraints.append(pc)
        return pc
    }
}
