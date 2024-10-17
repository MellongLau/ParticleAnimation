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
    var legIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        //verletView should add constraint for safe area layout guide
        verletView.translatesAutoresizingMaskIntoConstraints = false
        verletView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        verletView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        verletView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        verletView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        view.backgroundColor = UIColor.black
        displayLink?.add(to: RunLoop.current, forMode: RunLoop.Mode.default)

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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        displayLink?.invalidate()
        displayLink = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
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
    }
}
