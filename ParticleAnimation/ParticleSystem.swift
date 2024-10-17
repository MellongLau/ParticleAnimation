//
//  ParticleSystem.swift
//  ParticleAnimation
//
//  Created by Long on 2018/3/25.
//  Copyright © 2018年 Long. All rights reserved.
//

import UIKit

class SystemDemoView: UIView {
    var particles = [Particle2]()
    var pressure = Vec2(x: 0.4, y: 0)
    var repeller: Repeller!
    var particleSystem: ParticleSystem!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configuration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configuration()
    }
    
    func configuration() {
        backgroundColor = UIColor.blue
        repeller = Repeller(position: Vec2(x: Float(width/2), y: Float(height/2)))
        particleSystem = ParticleSystem(origin: CGPoint(x: 0, y: (height/2)), height: 200, viewSize: bounds.size)
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        particleSystem.applyForce(force: pressure)
        particleSystem.applyRepeller(r: repeller)
        repeller.display(context: context)
        particleSystem.addParticle()
        particleSystem.run(context: context)
        
    }
}

class ParticleSystem {

    var origin = CGPoint.zero
    var height: CGFloat = 0.0
    var size = CGSize.zero
    var particles = [Particle2]()
    init(origin: CGPoint, height: CGFloat, viewSize: CGSize) {
        self.origin = origin
        self.height = height
        self.size = viewSize
    }


    func addParticle() {
        for _ in 0..<10 {
            let center = Int(height/2)
            let random = Random()[-center, center].float
            let startPos = Vec2(x: origin.x.float, y: origin.y.float + random)
            particles.append(Particle2(position: startPos))
        }
    }
    
    func applyForce(force: Vec2) {
        for item in particles {
            item.applyForce(force: force)
        }
    }
    
    func applyRepeller(r: Repeller) {
        for item in particles {
            let force = r.calculateRepelForce(particle: item)
            item.applyForce(force: force)
        }
    }
    
    
    func run(context: CGContext) {
        for i in stride(from: particles.count - 1, through: 0, by: -1) {
            let item = particles[i]
            item.run(context: context)
            if item.isDead() || item.position.x.cgFloat > size.width || item.position.y.cgFloat < 0 || item.position.y.cgFloat > size.height {
                particles.remove(at: i)
            }
        }
    }
}

class Particle2{
    var acceleration = Vec2(x: 0, y: 0.05)
    var velocity = Vec2(x: (rand[0, 200] - 100).float / 100.0, y: (rand[0, 100] - 100).float / 100.0)
    var position = Vec2(x: 0, y: 0)
    var timeToLive: CGFloat = 255.0
    var mass: Float = 10
    
    
    init(position: Vec2) {
        self.position = position
        
    }
    
    func run(context: CGContext) {
        update()
        display(context: context)
    }
    
    func update() {
        let _ = velocity.mutableAdd(v: acceleration)
        let _ = position.mutableAdd(v: velocity)
        let _ = acceleration.mutableMul(v: Vec2(x: 0, y: 0))
        timeToLive -= 2
    }
    
    func display(context: CGContext) {
        context.setLineWidth(2)
        let path = CGPath(ellipseIn: CGRect(origin: position.toCGPoint(), size: CGSize(width: 12, height: 12)), transform: nil)
        UIColor(red: 1, green: 1, blue: 1, alpha: timeToLive/255.0).setStroke()
        UIColor(red: 210.0/255.0, green: 210.0/255.0, blue: 1.0, alpha: timeToLive/255.0).setFill()
        context.addPath(path)
        context.drawPath(using: .fillStroke)
    }

    func isDead() -> Bool {
        if timeToLive < 0{
            return true
        }else {
            return false
        }
    }
    
    func applyForce(force: Vec2) {
        _ = force.div(v: Vec2(x: mass, y: mass))
        _ = acceleration.mutableAdd(v: force)
    }
    
}

class Repeller {
    var power: CGFloat = 500.0
    var position = Vec2(x: 0, y: 0)
    init(position: Vec2) {
        self.position = position
    }
    
    func display(context: CGContext) {
        context.setFillColor(UIColor.red.cgColor)
        context.addArc(center: position.toCGPoint(), radius: 2, startAngle: 0, endAngle: (2 * Double.pi).cgFloat, clockwise: true)
        context.fillPath()
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
