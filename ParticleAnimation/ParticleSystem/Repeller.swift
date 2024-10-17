//
//  Repeller.swift
//  ParticleAnimation
//
//  Created by mellong on 2024/10/17.
//  Copyright © 2024 Long. All rights reserved.
//

import UIKit

class Repeller {
    var power: CGFloat = 500.0
    var position = Vec2(x: 0, y: 0)
    var strength: Float

    init(position: Vec2, strength: Float = 200.0) {
        self.position = position
        self.strength = strength
    }
    
    func display(context: CGContext) {
        context.setFillColor(UIColor.red.cgColor)
        context.addArc(center: position.toCGPoint(), radius: 5, startAngle: 0, endAngle: (2 * Double.pi).cgFloat, clockwise: true)
        context.fillPath()
    }

    func repel(particle: Particle2) -> Vec2 {
        var dir = Vec2(x: position.x - particle.position.x, y: position.y - particle.position.y)
        let d = dir.mag()
        dir.normalize()
        let force = -1 * strength / (d * d)
        dir.mult(force)
        return dir
    }

    func calculateRepelForce(particle: Particle2) -> Vec2 {
        var distance = self.position.dist(v: particle.position)
        let dir  = self.position.sub(v: particle.position)
        var normal = dir.normal()
        distance = min(100, distance)
        distance = max(1, distance)
        
        let force = -1.0 * power.float / (distance * distance)
        
        _ = normal.mutableMul(v: Vec2(x: force, y: force))
        return normal
        
    }
    
}
