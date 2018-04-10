//
//  Spider.swift
//  ParticleAnimation
//
//  Created by Mellong on 03/03/2018.
//  Copyright © 2018 Long. All rights reserved.
//

import UIKit

fileprivate struct AssociatedKeys {
    static var legs: UInt8 = 0
    static var head: UInt8 = 0
    static var thorax: UInt8 = 0
    static var abdomen: UInt8 = 0
//    static var thorax: UInt8 = 0
}

extension Composite {
    var legs: [Particle]? {
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.legs) as? [Particle] else {
                return nil
            }
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.legs, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var head: Particle? {
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.head) as? Particle else {
                return nil
            }
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.head, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var thorax: Particle? {
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.thorax) as? Particle else {
                return nil
            }
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.thorax, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var abdomen: Particle? {
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.abdomen) as? Particle else {
                return nil
            }
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.abdomen, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension VerletView {
    
    func spider(origin: Vec2) -> Composite {
        let legSeg1Stiffness: Float = 0.99
        let legSeg2Stiffness: Float = 0.99
        let legSeg3Stiffness: Float = 0.99
        let legSeg4Stiffness: Float = 0.99
        
        let joint1Stiffness: Float = 1
        let joint2Stiffness: Float = 0.4
        let joint3Stiffness: Float = 0.9
        
        let bodyStiffness: Float = 1
        let bodyJointStiffness: Float = 1
        
        let composite = Composite()
        var legs = [Particle]()
        
        
        composite.thorax = Particle(origin)
        composite.head = Particle(origin.add(v: Vec2(x: 0, y: -5)))
        composite.abdomen = Particle(origin.add(v: Vec2(x: 0, y: 10)))
        
        composite.particles.append(composite.thorax!)
        composite.particles.append(composite.head!)
        composite.particles.append(composite.abdomen!)
        
        composite.constraints.append(DistanceConstraint(a: composite.head!, b: composite.thorax!, stiffness: bodyStiffness))
        
        
        composite.constraints.append(DistanceConstraint(a: composite.abdomen!, b: composite.thorax!, stiffness: bodyStiffness))
        composite.constraints.append(AngleConstraint(a: composite.abdomen!, b: composite.thorax!, c: composite.head!, stiffness: 0.4))
        
        
        // legs
        for i in 0..<4 {
            composite.particles.append(Particle(composite.particles[0].pos.add(v: Vec2(x: 3, y: (i.float - 1.5) * 3))))
            composite.particles.append(Particle(composite.particles[0].pos.add(v: Vec2(x: -3, y: (i.float - 1.5) * 3))))
            
            var len = composite.particles.count
            
            composite.constraints.append(DistanceConstraint(a: composite.particles[len-2], b: composite.thorax!, stiffness: legSeg1Stiffness))
            composite.constraints.append(DistanceConstraint(a: composite.particles[len-1], b: composite.thorax!, stiffness: legSeg1Stiffness))
            
            
            var lenCoef: Float = 1.0
            if i == 1 || i == 2 {
                lenCoef = 0.7
            }else if i == 3 {
                lenCoef = 0.9
            }
            
            var v1 = Vec2(x: 20,y: (i.float-1.5)*30).normal()
            composite.particles.append(Particle(composite.particles[len-2].pos.add(v: v1.mutableScale(coef: 20*lenCoef))))
            var v2 = Vec2(x: -20,y: (i.float-1.5)*30).normal()
            composite.particles.append(Particle(composite.particles[len-1].pos.add(v: v2.mutableScale(coef: 20*lenCoef))))
            
            len = composite.particles.count
            composite.constraints.append(DistanceConstraint(a: composite.particles[len-4], b: composite.particles[len-2], stiffness: legSeg2Stiffness))
            composite.constraints.append(DistanceConstraint(a: composite.particles[len-3], b: composite.particles[len-1], stiffness: legSeg2Stiffness))
            
            var v3 = Vec2(x: 20, y: (i.float-1.5)*50).normal()
            composite.particles.append(Particle(composite.particles[len-2].pos.add(v: v3.mutableScale(coef: 20*lenCoef))))
            var v4 = Vec2(x: -20, y: (i.float-1.5)*50).normal()
            composite.particles.append(Particle(composite.particles[len-1].pos.add(v: v4.mutableScale(coef: 20*lenCoef))))
            
            len = composite.particles.count
            composite.constraints.append(DistanceConstraint(a: composite.particles[len-4], b: composite.particles[len-2], stiffness: legSeg3Stiffness))
            composite.constraints.append(DistanceConstraint(a: composite.particles[len-3], b: composite.particles[len-1], stiffness: legSeg3Stiffness))
            
            var v5 = Vec2(x: 20, y: (i.float-1.5)*100).normal()
            let rightFoot = Particle(composite.particles[len-2].pos.add(v: v5.mutableScale(coef: 12*lenCoef)))
            var v6 = Vec2(x: -20, y: (i.float-1.5)*100).normal()
            let leftFoot = Particle(composite.particles[len-1].pos.add(v: v6.mutableScale(coef: 12*lenCoef)))
            composite.particles.append(rightFoot)
            composite.particles.append(leftFoot)
            
            legs.append(rightFoot)
            legs.append(leftFoot)
            
            composite.legs = legs
            
            len = composite.particles.count
            composite.constraints.append(DistanceConstraint(a: composite.particles[len-4], b: composite.particles[len-2], stiffness: legSeg4Stiffness))
            composite.constraints.append(DistanceConstraint(a: composite.particles[len-3], b: composite.particles[len-1], stiffness: legSeg4Stiffness))
            
            
            composite.constraints.append(AngleConstraint(a: composite.particles[len-6], b: composite.particles[len-4], c: composite.particles[len-2], stiffness: joint3Stiffness))
            composite.constraints.append(AngleConstraint(a: composite.particles[len-6+1], b: composite.particles[len-4+1], c: composite.particles[len-2+1], stiffness: joint3Stiffness))
            
            composite.constraints.append(AngleConstraint(a: composite.particles[len-8], b: composite.particles[len-6], c: composite.particles[len-4], stiffness: joint2Stiffness))
            composite.constraints.append(AngleConstraint(a: composite.particles[len-8+1], b: composite.particles[len-6+1], c: composite.particles[len-4+1], stiffness: joint2Stiffness))
            
            composite.constraints.append(AngleConstraint(a: composite.particles[0], b: composite.particles[len-8], c: composite.particles[len-6], stiffness: joint1Stiffness))
            composite.constraints.append(AngleConstraint(a: composite.particles[0], b: composite.particles[len-8+1], c: composite.particles[len-6+1], stiffness: joint1Stiffness))
            
            composite.constraints.append(AngleConstraint(a: composite.particles[1], b: composite.particles[0], c: composite.particles[len-8], stiffness: bodyJointStiffness))
            composite.constraints.append(AngleConstraint(a: composite.particles[1], b: composite.particles[0], c: composite.particles[len-8+1], stiffness: bodyJointStiffness))
        }
        
        composites.append(composite)
        return composite
    }
    
    func spiderweb(origin: Vec2, radius: Float, segments: Int, depth: Int) -> Composite {
        let stiffness: Float = 0.6
        let tensor: Float = 0.3
        let spiderStride: Float = (2 * Double.pi).float / segments.float
        let n = segments * depth
        let radiusStride = radius / n.float
        
        let composite = Composite()
        
        // particles
        for i in 0..<n {
            let theta = i.float*spiderStride + cos(i.float*0.4)*0.05 + cos(i.float*0.05)*0.2
            let shrinkingRadius = radius - radiusStride*i.float + cos(i.float*0.1)*20
            
            let offy = cos(theta * 2.1) * (radius / depth.float) * 0.2
            composite.particles.append(Particle(Vec2(x: origin.x + cos(theta)*shrinkingRadius, y: origin.y + sin(theta)*shrinkingRadius + offy)))
        }
        
        for i in stride(from: 0, to: segments, by: 4) {
            _ = composite.pin(index: i)
        }
        // constraints
        for i in 0..<(n-1) {
            // neighbor
            composite.constraints.append(DistanceConstraint(a: composite.particles[i], b: composite.particles[i+1], stiffness: stiffness))
            
            // span rings
            let off = i + segments
            if off < n-1 {
                composite.constraints.append(DistanceConstraint(a: composite.particles[i], b: composite.particles[off], stiffness: stiffness))
            }else {
                composite.constraints.append(DistanceConstraint(a: composite.particles[i], b: composite.particles[n-1], stiffness: stiffness))
            }
        }
        
        
        composite.constraints.append(DistanceConstraint(a: composite.particles[0], b: composite.particles[segments-1], stiffness: stiffness))
        
        for c in 0..<composite.constraints.count {
            if let constraint = composite.constraints[c] as? DistanceConstraint {
                constraint.distance *= tensor
            }
        }
        
        composites.append(composite)
        return composite
    }
    
    func crawl(leg: Int) {
        let stepRadius: Float = 100
        let minStepRadius: Float = 35
        
        let spiderweb = composites[0]
        let spider = composites[1]
        
        let theta = spider.particles[0].pos.angle2(vLeft: spider.particles[0].pos.add(v: Vec2(x: 1, y: 0)), vRight: spider.particles[1].pos)
        
        let boundry1 = Vec2(x: cos(theta), y: sin(theta))
        let boundry2 = Vec2(x: cos(theta.double + Double.pi/2).float, y: sin(theta.double + Double.pi/2).float)
        
        
        let flag1 = leg < 4 ? 1 : -1
        let flag2 = leg % 2 == 0 ? 1 : 0
        
        var paths = [Particle]()
        for i in 0..<spiderweb.particles.count {
            if
                spiderweb.particles[i].pos.sub(v: spider.particles[0].pos).dot(v: boundry1)*flag1.float >= 0
                    && spiderweb.particles[i].pos.sub(v: spider.particles[0].pos).dot(v: boundry2)*flag2.float >= 0
            {
                let d2 = spiderweb.particles[i].pos.dist2(v: spider.particles[0].pos)
                
                if !(d2 >= minStepRadius*minStepRadius && d2 <= stepRadius*stepRadius) {
                    continue
                }
                
                var leftFoot = false
                for j in 0..<spider.constraints.count {
                    for k in 0..<8 {
                        if let constraint = spider.constraints[j] as? DistanceConstraint, let legs = spider.legs,
                            constraint.a == legs[k] && constraint.b == spiderweb.particles[i]
                        {
                            leftFoot = true
                        }
                    }
                }
                
                if !leftFoot {
                    paths.append(spiderweb.particles[i])
                }
            }
        }
        
        for i in 0..<spider.constraints.count {
            if let constraint = spider.constraints[i] as? DistanceConstraint, let legs = spider.legs, constraint.a == legs[leg] {
                spider.constraints.remove(at: i)
                break
            }
        }
        
        if let legs = spider.legs, paths.count > 0 {
            paths.shuffle()
            spider.constraints.append(DistanceConstraint(a: legs[leg], b: paths[0], stiffness: 1, distance: 0))
        }
    }

    
}
