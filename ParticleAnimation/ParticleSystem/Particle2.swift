//
//  Particle2.swift
//  ParticleAnimation
//
//  Created by mellong on 2024/10/17.
//  Copyright © 2024 Long. All rights reserved.
//

import UIKit

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
        _ = velocity.mutableAdd(v: acceleration)
        _ = position.mutableAdd(v: velocity)
        _ = acceleration.mutableMul(v: Vec2(x: 0, y: 0))
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
