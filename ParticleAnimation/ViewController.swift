//
//  ViewController.swift
//  ParticleAnimation
//
//  Created by Mellong on 02/03/2018.
//  Copyright © 2018 Long. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var verletView: VerletView?
    var displayLink: CADisplayLink?
    var systemDemoView: SystemDemoView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        displayLink = CADisplayLink(target: self, selector: #selector(drawFrame))
   
        if #available(iOS 10.0, *) {
            self.displayLink?.preferredFramesPerSecond = 60
        }
        
        verletView = VerletView(frame: view.bounds)
        
        guard let verletView = verletView else {
            return
        }
        verletView.backgroundColor = UIColor.white
        view.addSubview(verletView)
        view.backgroundColor = UIColor.white
        displayLink?.add(to: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)

        guard let title = title else {
            return
        }
        
        if title == "Spider" {
            spiderDemo(verletView)
        } else if title == "Shape" {
            shapeDemo(verletView)
        } else if title == "Cloth" {
            clothDemo(verletView)
        } else if title == "Tree" {
            treeDemo(verletView)
        } else if title == "Particle System" {
            systemDemoView = SystemDemoView(frame: view.bounds)
            view.addSubview(systemDemoView!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var legIndex = 0
    @objc func drawFrame() {
        
        if title == "Particle System" {
            systemDemoView?.setNeedsDisplay()
        } else {
            if title == "Spider" {
                if floor(Double(rand[0, 100])/100.0*4) == 0 {
                    verletView?.crawl(leg: legIndex*3%8)
                    legIndex += 1
                }
            }
            verletView?.gotoFrame(step: 16)
            verletView?.setNeedsDisplay()
        }

        
//
    }
}
