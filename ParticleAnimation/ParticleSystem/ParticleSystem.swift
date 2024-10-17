//
//  ParticleSystem.swift
//  ParticleAnimation
//
//  Created by Long on 2018/3/25.
//  Copyright © 2018年 Long. All rights reserved.
//

import UIKit

class ParticleSystem {
    var particles = [Particle2]()
    var origin: Vec2
    var height: CGFloat
    var viewSize: CGSize
    let maxParticles = 500 // 限制最大粒子数量

    init(origin: CGPoint, height: CGFloat, viewSize: CGSize) {
        self.origin = Vec2(x: Float(origin.x), y: Float(origin.y))
        self.height = height
        self.viewSize = viewSize
    }

    func applyForce(force: Vec2) {
        for particle in particles {
            particle.applyForce(force: force)
        }
    }

    func applyRepeller(r: Repeller) {
        for particle in particles {
            let force = r.repel(particle: particle)
            particle.applyForce(force: force)
        }
    }

    func addParticle() {
        let particlesToAdd = 3 // 每次添加5个粒子
        for _ in 0..<particlesToAdd {
            if particles.count < maxParticles {
                let particle = Particle2(position: origin)
                particles.append(particle)
            }
        }
    }

    func run(context: CGContext) {
        for particle in particles {
            particle.update()
            particle.display(context: context)
        }
        particles = particles.filter { !$0.isDead() }
    }
}
