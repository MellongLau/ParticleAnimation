//
//  Constraint.swift
//  ParticleAnimation
//
//  Created by Mellong on 02/03/2018.
//  Copyright © 2018 Long. All rights reserved.
//

import UIKit

public protocol Constraint {
    func relax(stepCoef: Float)
    func draw(ctx: CGContext)
}
