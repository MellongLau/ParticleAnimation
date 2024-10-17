//
//  SystemDemoView.swift
//  ParticleAnimation
//
//  Created by mellong on 2024/10/17.
//  Copyright © 2024 Long. All rights reserved.
//

import UIKit

class SystemDemoView: UIView {
    var particles = [Particle2]()
    var pressure = Vec2(x: 0.4, y: 0)
    var repeller: Repeller!
    var particleSystem: ParticleSystem!
    var displayLink: CADisplayLink?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configuration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configuration()
    }
    
    func configuration() {
        backgroundColor = UIColor.darkGray
        repeller = Repeller(position: Vec2(x: Float(bounds.width/2), y: Float(bounds.height/2)), strength: 1500)
        particleSystem = ParticleSystem(origin: CGPoint(x: 0, y: (bounds.height/2)), height: 200, viewSize: bounds.size)
        
        // 使用 CADisplayLink 控制刷新频率
        displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink?.preferredFramesPerSecond = 60 // 降低刷新频率
        displayLink?.add(to: .main, forMode: .default)
    }
    
    @objc func update() {
        setNeedsDisplay()
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
