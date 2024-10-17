//
//  VerLetView.swift
//  ParticleAnimation
//
//  Created by Mellong on 02/03/2018.
//  Copyright © 2018 Long. All rights reserved.
//

import UIKit

class VerletView: UIView {
    var gravity: Vec2 = Vec2(x: 0, y: 0.2)
    var friction: Float = 0.99
    var groundFriction: Float = 0.8
    var composites = [Composite]()
    var highlightColor = UIColor(hex: "#4f545c")
    let selectionRadius: Float = 20.0
    var draggedEntity: Entity?
    var mouse = Vec2()
    var mouseDown = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        mouseDown = true
        if let touch = touches.first {
            let lastTouchLocation = touch.location(in: self)
            mouse = Vec2(x: lastTouchLocation.x.float, y: lastTouchLocation.y.float)
        }
        
        let nearest = nearestEntity()
        if let nearest = nearest {
            draggedEntity = nearest
        }
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let lastTouchLocation = touch.location(in: self)
            mouse = Vec2(x: lastTouchLocation.x.float, y: lastTouchLocation.y.float)
        }
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        mouse = Vec2()
        mouseDown = false
        draggedEntity = nil
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        mouse = Vec2()
        mouseDown = false
        draggedEntity = nil
    }
    
    public func limitInBounds(particle: Particle) -> Particle {
        let tmpParticle = particle
        if (tmpParticle.pos.y > height.float - 1) {
            tmpParticle.pos.y = height.float - 1
        }
        
        if (tmpParticle.pos.x < 0) {
            tmpParticle.pos.x = 0
        }
        
        if (tmpParticle.pos.x > width.float - 1) {
            tmpParticle.pos.x = width.float - 1
        }
        return tmpParticle
    }
    
    public func tire(origin: Vec2, radius: Float, segments: Int, spokeStiffness: Float, treadStiffness: Float) -> Composite {
        let stride = (2 * Double.pi) / Double(segments)
        let composite = Composite()
        
        // particles
        for i in 0..<segments {
            let theta = Double(i) * stride
            let particle = Particle(Vec2(x: origin.x + cos(theta).float * radius, y: origin.y + sin(theta).float * radius))
            composite.particles.append(particle)
        }
        
        let center = Particle(origin)
        composite.particles.append(center)
        
        // constraints
        for i in 0..<segments {
            let particle = composite.particles[i]
            
            composite.constraints.append(DistanceConstraint(a: particle, b: composite.particles[(i + 1) % segments], stiffness: treadStiffness))
            composite.constraints.append(DistanceConstraint(a: particle, b: center, stiffness: spokeStiffness))
            composite.constraints.append(DistanceConstraint(a: particle, b: composite.particles[(i + 5) % segments], stiffness: treadStiffness))
        }
        
        composites.append(composite)
        return composite
    }
    
    public func gotoFrame(step: Int) {
        
        for c in 0..<composites.count {
            for i in 0..<composites[c].particles.count {
                let particles = composites[c].particles

                // calculate velocity
                var velocity = particles[i].pos.sub(v: particles[i].lastPos).scale(coef: friction)

                // ground friction
                if (particles[i].pos.y >= height.float - 1 && velocity.length2() > 0.000001) {
                    let m = velocity.length()
                    velocity.x /= m
                    velocity.y /= m
                    _ = velocity.mutableScale(coef: m * groundFriction)
                }

                // save last good state
                _ = composites[c].particles[i].lastPos.mutableSet(v: particles[i].pos)

                // gravity
                _ = composites[c].particles[i].pos.mutableAdd(v: gravity)

                // inertia
                _ = composites[c].particles[i].pos.mutableAdd(v: velocity)
            }
        }
        
        // handle dragging of entities
        if let _ = draggedEntity {
            _ = draggedEntity?.pos.mutableSet(v: mouse) // temp remove
        }
        
        // relax
        let stepCoef = 1.0 / step.float
        for c in 0..<composites.count {
//            var constraints = composites[c].constraints
            for _ in 0..<step {
                for j in 0..<composites[c].constraints.count {
                    composites[c].constraints[j].relax(stepCoef: stepCoef)
                }
            }
            
        }
        
        //??think about array replace item
        // bounds checking
        for c in 0..<composites.count {
            let particles = composites[c].particles
            for i in 0..<particles.count {
                composites[c].particles[i] = limitInBounds(particle: particles[i])
            }
        }
    }
    
    //uncomplete
    override func draw(_ rect: CGRect) {
        let unsafeCtx = UIGraphicsGetCurrentContext()
        guard let ctx = unsafeCtx else {
            return
        }

        ctx.setFillColor(UIColor.white.cgColor)
        ctx.fill(CGRect(x: 0, y: 0, width: width, height: height))
        
        for c in 0..<composites.count {
            // draw constraints
            if let drawConstraints = composites[c].drawConstraints {
                drawConstraints(ctx, composites[c])
            } else {
                let constraints = composites[c].constraints
                for i in 0..<constraints.count {
                    constraints[i].draw(ctx: ctx)
                }
            }
            
            // draw particles
            if let drawParticles = composites[c].drawParticles {
                drawParticles(ctx, composites[c])
            } else {
                let particles = composites[c].particles
                for i in 0..<particles.count {
                    particles[i].draw(ctx: ctx)
                }
            }
        }
        
        // highlight nearest / dragged entity
        let nearest = draggedEntity ?? nearestEntity()
        if let nearest = nearest {
//            ctx.beginPath()
            ctx.setStrokeColor(highlightColor.cgColor)
            ctx.addArc(center: nearest.pos.toCGPoint(), radius: 8.0, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
            ctx.strokePath()
        }
        
        
    }
    
    public func nearestEntity() -> Entity? {
        var d2Nearest: Float = 0.0
        var entity: Entity? = nil
        var constraintsNearest: [Entity]? = nil
        
        // find nearest point
        for c in 0..<composites.count {
            let particles = composites[c].particles
            for i in 0..<particles.count {
                let d2 = particles[i].pos.dist2(v: mouse)
                if d2 <= selectionRadius * selectionRadius && (entity == nil || d2 < d2Nearest) {
                    entity = particles[i]
                    constraintsNearest = composites[c].constraints as? [Entity]
                    d2Nearest = d2
                }
            }
        }
        
        // search for pinned constraints for this entity
        if let constraintsNearest = constraintsNearest {
            for i in 0..<constraintsNearest.count {
                let constraint = constraintsNearest[i]
                if let item = constraint as? PinConstraint, let entityParticle = entity as? Particle {
                    if item.a == entityParticle {
                        entity = constraint
                    }
                }
            }
        }
        
        return entity
    }
    
    public func point(pos: Vec2) -> Composite {
        let composite = Composite()
        composite.particles.append(Particle(pos))
        composites.append(composite)
        return composite
    }
    
    public func lineSegments(vertices: [Vec2], stiffness: Float) -> Composite {
        let composite = Composite()
        
        for i in 0..<vertices.count {
            composite.particles.append(Particle(vertices[i]))
            if i > 0 {
                composite.constraints.append(DistanceConstraint(a: composite.particles[i], b: composite.particles[i - 1], stiffness: stiffness))
            }
        }
        
        composites.append(composite)
        return composite;
    }
    
    public func cloth(origin: Vec2, width: Float, height: Float, segments: Int, pinMod: Int, stiffness: Float) -> Composite {
        let composite = Composite()
        
        let xStride = width / segments.float
        let yStride = height / segments.float
        
        for y in 0..<segments {
            for x in 0..<segments {
                let px = origin.x + x.float*xStride - width/2 + xStride/2;
                let py = origin.y + y.float*yStride - height/2 + yStride/2;
                composite.particles.append(Particle(Vec2(x: px, y: py)));
                
                if x > 0 {
                    composite.constraints.append(DistanceConstraint(a: composite.particles[y*segments+x], b: composite.particles[y*segments+x-1], stiffness: stiffness))
                }
                
                if y > 0 {
                    composite.constraints.append(DistanceConstraint(a: composite.particles[y*segments+x], b: composite.particles[(y-1)*segments+x], stiffness: stiffness));
                }
            }
        }
        
        for x in 0..<segments {
            if x % pinMod == 0 {
                _ = composite.pin(index: x)
            }
        }
        
        composites.append(composite)
        return composite
    }
}
