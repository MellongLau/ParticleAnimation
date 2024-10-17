//
//  Demo.swift
//  ParticleAnimation
//
//  Created by Mellong on 04/03/2018.
//  Copyright © 2018 Long. All rights reserved.
//

import UIKit

func shapeDemo(_ verletView: VerletView) {
    // simulation
    verletView.friction = 1
    
    // entities
    let segment = verletView.lineSegments(vertices: [Vec2(x: 20, y:100), Vec2(x: 40, y:10), Vec2(x: 60, y:10), Vec2(x: 80, y:10), Vec2(x: 100, y: 100)], stiffness: 0.02)
    _ = segment.pin(index: 0)
    _ = segment.pin(index: 4)
    
    _ = verletView.tire(origin: Vec2(x: 200, y: 50), radius: 50, segments: 30, spokeStiffness: 0.3, treadStiffness: 0.9)
    _ = verletView.tire(origin: Vec2(x: 400, y: 50), radius: 70, segments: 7, spokeStiffness: 0.1, treadStiffness: 0.2)
    _ = verletView.tire(origin: Vec2(x: 300, y: 50), radius: 70, segments: 3, spokeStiffness: 1, treadStiffness: 1)
}

func treeDemo(_ sim: VerletView) {
    sim.gravity = Vec2(x: 0, y: 0)
    sim.friction = 0.98
    
    // entities
    _ = sim.tree(origin: Vec2(x: Float(sim.width / 4.0), y: Float(sim.height - 120.0)), depth: 5.0, branchLength: 70.0, segmentCoef: 0.95, theta: (Float.pi / 2) / 3)
    let tree2 = sim.tree(origin: Vec2(x: Float(sim.width - sim.width / 4.0), y: Float(sim.height - 120.0)), depth: 5.0, branchLength: 70.0, segmentCoef: 0.95, theta: (Float.pi / 2) / 3)
    
    tree2.drawParticles = { (ctx, composite) -> Void in
        ctx.saveGState()
        ctx.setFillColor(UIColor(hex: "#679d7c").cgColor)
        for i in 0..<composite.particles.count {
            let particle = composite.particles[i]
            if (particle.leaf) {
                ctx.addArc(center: particle.pos.toCGPoint(), radius: 25, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
                ctx.fillPath()
            }
        }
        ctx.restoreGState()
    }
    
    tree2.drawConstraints = { (ctx, composite) -> Void in
        
        ctx.saveGState()
        ctx.setStrokeColor(UIColor(hex: "#543324").cgColor)
        ctx.setLineCap(.round)
        
        for i in 0..<composite.constraints.count {
            let constraint = composite.constraints[i]
            if let constraint = constraint as? DistanceConstraint, constraint.p != Float.greatestFiniteMagnitude {
                ctx.move(to: constraint.a.pos.toCGPoint())
                ctx.addLine(to: constraint.b.pos.toCGPoint())
                ctx.setLineWidth(lerp(10, 2, constraint.p).cgFloat)
                ctx.strokePath()
            }
        }
        
        ctx.restoreGState()
    }
}

func clothDemo(_ sim: VerletView) {
    // simulation
    sim.friction = 1
    sim.highlightColor = UIColor.white
    
    // entities
    let minSide = min(sim.width, sim.height) * 0.5
    let segments = 20
    let cloth = sim.cloth(origin: Vec2(x: sim.width.float / 2, y: sim.height.float / 3), width: minSide.float, height: minSide.float, segments: segments, pinMod: 6, stiffness: 0.9)
    
    cloth.drawConstraints = { (ctx, composite) in
        let stride = minSide.float / segments.float
        for y in 1..<segments {
            for x in 1..<segments {
                let i1 = (y - 1) * segments + x - 1
                let i2 = y * segments + x
                
                ctx.move(to: cloth.particles[i1].pos.toCGPoint())
                ctx.addLine(to: cloth.particles[i1 + 1].pos.toCGPoint())
                
                ctx.addLine(to: cloth.particles[i2].pos.toCGPoint())
                ctx.addLine(to: cloth.particles[i2 - 1].pos.toCGPoint())
                
                var off = cloth.particles[i2].pos.x - cloth.particles[i1].pos.x
                off += cloth.particles[i2].pos.y - cloth.particles[i1].pos.y
                off *= 0.25
                
                var coef = round((abs(off) / stride) * 255)
                if coef > 255 {
                    coef = 255
                }
                ctx.setFillColor(UIColor(red: coef.cgFloat/255.0, green: 0, blue: (255 - coef).cgFloat/255.0, alpha: lerp(0.25, 1, coef/255.0).cgFloat).cgColor)
                ctx.fillPath()
            }
        }
        
        for c in 0..<composite.constraints.count {
            if let point = composite.constraints[c] as? PinConstraint {
                ctx.addArc(center: point.pos.toCGPoint(), radius: 1.2, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
                ctx.setFillColor(UIColor.white.cgColor)
                ctx.fillPath()
            }
        }
    }
    
    cloth.drawParticles = { (ctx, composite) in
        // do nothing for particles
    }
}

func spiderDemo(_ sim: VerletView) {
    // entities
    let spiderweb = sim.spiderweb(origin: Vec2(x: sim.width.float/2, y: sim.height.float/2), radius: min(sim.width, sim.height).float/2, segments: 20, depth: 7)
    
    let spider = sim.spider(origin: Vec2(x: sim.width.float/2,y: -300))
    
    
    spiderweb.drawParticles = { (ctx, composite) -> Void in
        for i in 0..<composite.particles.count {
            let point = composite.particles[i]
            ctx.setFillColor(UIColor(hex: "#2dad8f").cgColor)
            ctx.addArc(center: point.pos.toCGPoint(), radius: 1.3, startAngle: 0, endAngle: CGFloat(2*Double.pi), clockwise: true)
            ctx.fillPath()
        }
    }
    
    spider.drawConstraints = { (ctx, composite) -> Void in
        
        guard let head = spider.head, let thorax = spider.thorax, let abdomen = spider.abdomen else {
            return
        }
        
        ctx.setFillColor(UIColor.black.cgColor)
        ctx.addArc(center: head.pos.toCGPoint(), radius: 4, startAngle: 0, endAngle: CGFloat(2*Double.pi), clockwise: true)
        ctx.addArc(center: thorax.pos.toCGPoint(), radius: 4, startAngle: 0, endAngle: CGFloat(2*Double.pi), clockwise: true)
        ctx.addArc(center: abdomen.pos.toCGPoint(), radius: 18, startAngle: 0, endAngle: CGFloat(2*Double.pi), clockwise: true)
        ctx.fillPath()
        
        for i in 0..<composite.constraints.count {
            
            if let constraint = composite.constraints[i] as? DistanceConstraint {
                
                ctx.saveGState()
                ctx.setStrokeColor(UIColor.black.cgColor)
                ctx.move(to: constraint.a.pos.toCGPoint())
                ctx.addLine(to: constraint.b.pos.toCGPoint())
                
                // draw legs
                if (i >= 2 && i <= 4)
                    || (i >= (2*9)+1 && i <= (2*9)+2)
                    || (i >= (2*17)+1 && i <= (2*17)+2)
                    || (i >= (2*25)+1 && i <= (2*25)+2)
                {
                    ctx.setLineWidth(3)
                    
                } else if
                    (i >= 4 && i <= 6)
                        || (i >= (2*9)+3 && i <= (2*9)+4)
                        || (i >= (2*17)+3 && i <= (2*17)+4)
                        || (i >= (2*25)+3 && i <= (2*25)+4)
                {
                    ctx.setLineWidth(2)
                } else if
                    (i >= 6 && i <= 8)
                        || (i >= (2*9)+5 && i <= (2*9)+6)
                        || (i >= (2*17)+5 && i <= (2*17)+6)
                        || (i >= (2*25)+5 && i <= (2*25)+6)
                {
                    ctx.setLineWidth(1.5)
                } else {
                    
                }
                
                ctx.strokePath()
                ctx.restoreGState()
            }
        }
    }
    
    spider.drawParticles = { (ctx, composite) in
    }
}
