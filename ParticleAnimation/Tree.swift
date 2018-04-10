//
//  Tree.swift
//  ParticleAnimation
//
//  Created by Mellong on 03/03/2018.
//  Copyright © 2018 Long. All rights reserved.
//

import UIKit

fileprivate struct AssociatedKeys {
    static var leaf: UInt8 = 0
    static var p: UInt8 = 0
}

func lerp(_ a: Float, _ b: Float, _ p: Float) -> Float {
    return (b-a)*p + a
}

extension Particle {
    var leaf: Bool {
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.leaf) as? Bool else {
                return false
            }
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.leaf, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
}

extension DistanceConstraint {
    var p: Float {
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.p) as? Float else {
                return Float.greatestFiniteMagnitude
            }
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.p, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}


extension VerletView {
    
    public func tree(origin: Vec2, depth: Float, branchLength: Float, segmentCoef: Float, theta: Float) -> Composite{
        let lineCoef: Float = 0.7
        let origin = origin
        let base = Particle(origin)
        let root = Particle(origin.add(v: Vec2(x: 0, y: 10)))
        
        let composite = Composite()
        composite.particles.append(base)
        composite.particles.append(root)
        _ = composite.pin(index: 0)
        _ = composite.pin(index: 1)
        var branch: ((Particle, Float, Float, Float, Vec2) -> Particle)!
        branch = { (parent: Particle, i: Float, nMax: Float, coef: Float, normal: Vec2) -> Particle in
            let particle = Particle(parent.pos.add(v: normal.scale(coef: branchLength * coef)))
            composite.particles.append(particle)
            let dc = DistanceConstraint(a: parent, b: particle, stiffness: lineCoef)
            dc.p = i / nMax // a hint for drawing
            composite.constraints.append(dc)
            
            particle.leaf = !(i < nMax)
            
            if (i < nMax)
            {
                let a = branch(particle, i + 1, nMax, coef * coef, normal.rotate(origin: Vec2(x: 0, y: 0), theta: -theta))
                let b = branch(particle, i + 1, nMax, coef * coef, normal.rotate(origin: Vec2(x: 0, y: 0), theta: theta))
                let jointStrength = lerp(0.7, 0, i/nMax)
                composite.constraints.append(AngleConstraint(a: parent, b: particle, c: a, stiffness: jointStrength))
                composite.constraints.append(AngleConstraint(a: parent, b: particle, c: b, stiffness: jointStrength))
            }
            
            return particle
        }
        
        let firstBranch = branch(base, 0, depth, segmentCoef, Vec2(x: 0, y: -1))
        
        composite.constraints.append(AngleConstraint(a: root, b: base, c: firstBranch, stiffness: 1))
        
        // animates the tree at the beginning
        for i in 0..<composite.particles.count {
            _ = composite.particles[i].pos.mutableAdd(v: Vec2(x: Float(rand(1, 10)) , y: Float(rand(1, 10))))
        }
        composites.append(composite)
        return composite
    }
    
}
